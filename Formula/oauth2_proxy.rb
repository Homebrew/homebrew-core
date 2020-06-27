class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/v6.0.0.tar.gz"
  sha256 "cff836f293895393f4cf853725cb7e72c9bee6e41f732e4e957420fc753a41e3"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1102bce51e1d9abb11007d053472d80632b210714e61e9c7cabf64d29d82bf72" => :catalina
    sha256 "b6e73955055c8141b69ba6ec4d68cb463925ded2db9200b88e6b776af5b22915" => :mojave
    sha256 "13c0f41d0cd1a6a872c6e732ca784a2bcb3b52b4f1cc738f102147c58266cced" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=#{version}",
                          "-trimpath",
                          "-o", bin/"oauth2-proxy"
    (etc/"oauth2-proxy").install "contrib/oauth2-proxy.cfg.example"
    bash_completion.install "contrib/oauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    <<~EOS
      #{etc}/oauth2-proxy/oauth2-proxy.cfg must be filled in.
    EOS
  end

  plist_options :manual => "oauth2-proxy"

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
              <string>#{opt_bin}/oauth2-proxy</string>
              <string>--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    require "timeout"

    port = free_port

    pid = fork do
      exec "#{bin}/oauth2-proxy",
        "--client-id=testing",
        "--client-secret=testing",
        # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
        "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=file:///tmp",
        "--email-domain=*"
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
