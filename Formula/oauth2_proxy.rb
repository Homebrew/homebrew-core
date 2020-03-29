class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://pusher.github.io/oauth2_proxy"
  url "https://github.com/pusher/oauth2_proxy/archive/v5.0.0.tar.gz"
  sha256 "a775357f3a8952da2495b423765fe7d77e2fbbe4c9282fc28e910642e27caafb"
  head "https://github.com/pusher/oauth2_proxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa2c02bd5d715dd0ea01ba9e253ed0909b363d40f7a6d716e0ef5baeae40cb67" => :catalina
    sha256 "3ce3d33e4db8a89eb3c2e4f78fb6e8964f3a1647ef90facd29cb3c4941c21963" => :mojave
    sha256 "3e9400a194397e4aeb85bc01d018554a5efcfa613e37096a20464738878f781b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=#{version}",
                          "-trimpath",
                          "-o", bin/"oauth2_proxy"
    (etc/"oauth2_proxy").install "contrib/oauth2_proxy.cfg.example"
    bash_completion.install "contrib/oauth2_proxy_autocomplete.sh" => "oauth2_proxy"
  end

  def caveats
    <<~EOS
      #{etc}/oauth2_proxy/oauth2_proxy.cfg must be filled in.
    EOS
  end

  plist_options :manual => "oauth2_proxy"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/oauth2_proxy</string>
              <string>--config=#{etc}/oauth2_proxy/oauth2_proxy.cfg</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    require "socket"
    require "timeout"

    # Get an unused TCP port.
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    pid = fork do
      exec "#{bin}/oauth2_proxy",
        "--client-id=testing",
        "--client-secret=testing",
        "--cookie-secret=testing",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=file:///tmp",
        "-email-domain=*"
    end

    begin
      Timeout.timeout(10) do
        loop do
          Utils.popen_read "curl", "-s", "http://127.0.0.1:#{port}"
          break if $CHILD_STATUS.exitstatus.zero?

          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
