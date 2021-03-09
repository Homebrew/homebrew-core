class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.0.1.tar.gz"
  sha256 "61a6ade340bef8a92e63e1a4be4d5498190b691f4eaeb4c7325dd66fbfe9bfd9"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54f7af022742e2f5e749aa2f1d6aac0e5130d7f017b178edae62deb760088d36"
    sha256 cellar: :any_skip_relocation, big_sur:       "fadef8f69ce44469257ece86f89f59f08746ff82303f3b5595c1509af841aee8"
    sha256 cellar: :any_skip_relocation, catalina:      "b2d59b973929760ce53e8ccfa248db721e9712889418b9fa51a05c8e416774c5"
    sha256 cellar: :any_skip_relocation, mojave:        "5a7952a20c808199260d81aa8e99b3d6ac9ea42257d1e969e631a0f8a0fed36f"
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

  plist_options manual: "oauth2-proxy"

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
