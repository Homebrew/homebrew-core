class Juicity < Formula
  desc "QUIC-based proxy protocol implementation"
  homepage "https://github.com/juicity/juicity/"
  url "https://github.com/juicity/juicity/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "dab433672ef7bb209443f5f668d1cb6f704ab9ac479013c7e9416b516340ca41"
  license "AGPL-3.0-or-later"
  head "https://github.com/juicity/juicity.git", branch: "main"

  depends_on "go" => :build
  depends_on "jq"

  def install
    system "make", "CGO_ENABLED=0", "juicity-server"
    system "make", "juicity-client"
    bin.install "juicity-server"
    bin.install "juicity-client"
    File.write bin/"juicity", <<~EOS
      #!/bin/bash
      set -e
      SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
      # Show help if no arguments provided
      if [ $# -eq 0 ]; then
        echo "Usage: juicity <command> [arguments]"
        echo ""
        echo "Commands:"
        echo "  server              Run server command"
        echo "  client              Run client command"
        echo "  help, -h, --help    Show this help"
        exit 1
      fi
      # Get the subcommand
      CMD=$1
      shift
      case "$CMD" in
      server)
        exec "$SCRIPT_DIR/juicity-server" "$@"
        ;;
      client)
        exec "$SCRIPT_DIR/juicity-client" "$@"
        ;;
      -h | --help | help)
        exec "$SCRIPT_DIR/juicity"
        ;;
      run)
        CONFIG=""
        args=()
        while [[ $# -gt 0 ]]; do
          case $1 in
          -c | --config)
            CONFIG="$2"
            shift 2
            ;;
          *)
            args+=("$1")
            shift
            ;;
          esac
        done
        # Check if config file is provided
        if [ -z "$CONFIG" ]; then
          echo "Error: Config file not specified"
          exit 1
        fi
        # Check if config file exists
        if [ ! -f "$CONFIG" ]; then
          echo "Error: Config file '$CONFIG' not found"
          exit 1
        fi
        # Determine if this is a server or client based on config content
        if jq -e 'has("users")' "$CONFIG" >/dev/null; then
          echo "Starting server mode..."
          exec "$SCRIPT_DIR/juicity-server" run -c "$CONFIG" "${args[@]}"
        elif jq -e 'has("server")' "$CONFIG" >/dev/null; then
          echo "Starting client mode..."
          exec "$SCRIPT_DIR/juicity-client" run -c "$CONFIG" "${args[@]}"
        else
          echo "Error: Invalid configuration format"
          exit 1
        fi
        ;;
      *)
        echo "Error: unknown command '$CMD'"
        echo "Available commands: server, client"
        exit 1
        ;;
      esac
    EOS
    chmod 0555, bin/"juicity"
  end

  def post_install
    (etc/"juicity").mkpath
    File.write "#{etc}/juicity/server.json", <<~EOS
      {
        "listen": ":23182",
        "users": {
          "00000000-0000-0000-0000-000000000000": "my_password"
        },
        "certificate": "/path/to/fullchain.cer",
        "private_key": "/path/to/private.key",
        "congestion_control": "bbr",
        "log_level": "info",
        "fwmark": "0x1000",
        "send_through": "113.25.132.3",
        "dialer_link": "socks5://127.0.0.1:1080",
        "disable_outbound_udp443": true
      }
    EOS
    File.write "#{etc}/juicity/client.json", <<~EOS
      {
        "listen": ":1080",
        "server": "<ip or domain>:<port>",
        "uuid": "00000000-0000-0000-0000-000000000000",
        "password": "my_password",
        "sni": "www.example.com",
        "allow_insecure": false,
        "congestion_control": "bbr",
        "log_level": "info",
        "pinned_certchain_sha256": "aQc4fdF4Nh1PD6MsCB3eofRyfRz5R8jJ1afgr37ABZs=",
        "forward": {
          "127.0.0.1:12322": "127.0.0.1:22",
          "0.0.0.0:5201/tcp": "127.0.0.1:5201",
          "0.0.0.0:5353/udp": "8.8.8.8:53"
        }
      }
    EOS
    (etc/"juicity").install_symlink etc/"juicity/server.json" => "config.json"
  end

  service do
    run [opt_bin/"juicity", "run", "-c", etc/"juicity/config.json"]
    working_dir opt_prefix
    keep_alive true
  end

  def caveats
    <<~EOS
      Server mode is running by default because `config.json` is symlinked to `server.json`,
      you can modify config files in #{etc}/juicity
    EOS
  end

  test do
    (testpath/"test.cer").write <<~EOS
      -----BEGIN CERTIFICATE-----
      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
      -----END CERTIFICATE-----
    EOS
    (testpath/"test.key").write <<~EOS
      -----BEGIN PRIVATE KEY-----
      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
      SchioE35FpM+IxB81PCMRMo1BDY9wrg=
      -----END PRIVATE KEY-----
    EOS
    server_port = free_port
    fork do
      server = TCPServer.new(server_port)
      loop do
        socket = server.accept
        socket.write "HTTP/1.1 200 OK\r\n" \
                     "Content-Type: text/plain; charset=utf-8\r\n" \
                     "Content-Length: 0\r\n" \
                     "\r\n"
        socket.close
      end
    end
    (testpath/"server.json").write <<~JSON
      {
        "listen": ":#{server_port}",
        "users": {
          "00000000-0000-0000-0000-000000000000": "my_password"
        },
        "certificate": "test.cer",
        "private_key": "test.key",
        "congestion_control": "bbr",
        "disable_outbound_udp443": true,
        "log_level": "info"
      }
    JSON
    server = fork { exec bin/"juicity-server", "run", "-c", testpath/"server.json" }
    client_port = free_port
    (testpath/"client.json").write <<~JSON
      {
        "listen": ":#{client_port}",
        "server": "127.0.0.1:#{server_port}",
        "uuid": "00000000-0000-0000-0000-000000000000",
        "password": "my_password",
        "sni": "localhost",
        "allow_insecure": true,
        "congestion_control": "bbr",
        "log_level": "info"
      }
    JSON
    client = fork { exec bin/"juicity-client", "run", "-c", testpath/"client.json" }
    sleep 5
    begin
      assert_match "<title>Example Domain</title>",
shell_output("curl --socks5 127.0.0.1:#{client_port} www.example.com")
      break
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
