#!/usr/bin/env bash
# ======================================================
#  CurlAI — Private Tor-Enabled Mini-AI Core Installer
#  Fully self-contained installer generated in one line
#  Creates isolated Tor instance + proxy config + dirs
# ======================================================

set -euo pipefail

BASE="$HOME/apps/curlai"
TOR_DIR="$BASE/tor"
ETC="$BASE/etc"
BIN="$BASE/bin"
DATA="$BASE/data"
LOGS="$BASE/logs"

echo "[+] Creating directory structure..."
mkdir -p "$TOR_DIR" "$ETC" "$BIN" "$DATA" "$LOGS"

echo "[+] Writing proxy.conf..."
cat > "$ETC/proxy.conf" << 'CONF'
###############################################
# CurlAI Proxy Configuration
# Private Tor instance (NO system Tor)
###############################################

proxy = on
proxytype = tor
proxyhost = 127.0.0.1
proxyport = 9550
tor_settings = enabled
CONF

echo "[+] Creating hardened torrc..."
cat > "$TOR_DIR/torrc" << 'TOR'
SocksPort 127.0.0.1:9550
ControlPort 127.0.0.1:9551
DataDirectory ./data

DNSPort 127.0.0.1:9552
AutomapHostsOnResolve 1
VirtualAddrNetworkIPv4 10.192.0.0/10

IsolateSOCKSAuth 1
SafeSocks 1
ClientUseIPv4 1
ClientUseIPv6 0
ClientPreferIPv6ORPort 0
AvoidDiskWrites 1
DisableDebuggerAttachment 1

Log notice stdout
TOR

echo "[+] Writing Tor start script..."
cat > "$BIN/start-tor.sh" << 'STS'
#!/usr/bin/env bash
cd "$(dirname "$0")/../tor"
tor -f torrc
STS
chmod +x "$BIN/start-tor.sh"

echo "[+] Writing Tor systemd user service..."
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/curlai-tor.service << EOF2
[Unit]
Description=CurlAI Private Tor Instance
After=network.target

[Service]
Type=simple
ExecStart=$BIN/start-tor.sh
WorkingDirectory=$TOR_DIR
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF2

echo "[+] Enabling CurlAI Tor service..."
systemctl --user daemon-reload
systemctl --user enable --now curlai-tor.service

echo "[✓] CurlAI private Tor subsystem installed."
echo "-----------------------------------------------"
echo " Tor SOCKS5     : 127.0.0.1:9550"
echo " Tor Control    : 127.0.0.1:9551"
echo " Config file    : $ETC/proxy.conf"
echo "-----------------------------------------------"
echo "[✓] Installation complete."
EOF
#!/usr/bin/env bash
# ======================================================
#  CurlAI — Private Tor-Enabled Mini-AI Core Installer
#  Fully self-contained installer generated in one line
#  Creates isolated Tor instance + proxy config + dirs
# ======================================================

set -euo pipefail

BASE="$HOME/apps/curlai"
TOR_DIR="$BASE/tor"
ETC="$BASE/etc"
BIN="$BASE/bin"
DATA="$BASE/data"
LOGS="$BASE/logs"

echo "[+] Creating directory structure..."
mkdir -p "$TOR_DIR" "$ETC" "$BIN" "$DATA" "$LOGS"

echo "[+] Writing proxy.conf..."
cat > "$ETC/proxy.conf" << 'CONF'
###############################################
# CurlAI Proxy Configuration
# Private Tor instance (NO system Tor)
###############################################

proxy = on
proxytype = tor
proxyhost = 127.0.0.1
proxyport = 9550
tor_settings = enabled
CONF

echo "[+] Creating hardened torrc..."
cat > "$TOR_DIR/torrc" << 'TOR'
SocksPort 127.0.0.1:9550
ControlPort 127.0.0.1:9551
DataDirectory ./data

DNSPort 127.0.0.1:9552
AutomapHostsOnResolve 1
VirtualAddrNetworkIPv4 10.192.0.0/10

IsolateSOCKSAuth 1
SafeSocks 1
ClientUseIPv4 1
ClientUseIPv6 0
ClientPreferIPv6ORPort 0
AvoidDiskWrites 1
DisableDebuggerAttachment 1

Log notice stdout
TOR

echo "[+] Writing Tor start script..."
cat > "$BIN/start-tor.sh" << 'STS'
#!/usr/bin/env bash
cd "$(dirname "$0")/../tor"
tor -f torrc
STS
chmod +x "$BIN/start-tor.sh"

echo "[+] Writing Tor systemd user service..."
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/curlai-tor.service << EOF2
[Unit]
Description=CurlAI Private Tor Instance
After=network.target

[Service]
Type=simple
ExecStart=$BIN/start-tor.sh
WorkingDirectory=$TOR_DIR
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF2

echo "[+] Enabling CurlAI Tor service..."
systemctl --user daemon-reload
systemctl --user enable --now curlai-tor.service

echo "[✓] CurlAI private Tor subsystem installed."
echo "-----------------------------------------------"
echo " Tor SOCKS5     : 127.0.0.1:9550"
echo " Tor Control    : 127.0.0.1:9551"
echo " Config file    : $ETC/proxy.conf"
echo "-----------------------------------------------"
echo "[✓] Installation complete."
# EOF
