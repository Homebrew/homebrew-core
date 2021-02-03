class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.0.0.tar.gz"
  sha256 "0f9ae240b032dff2be0e68680c088e241503b8c451c27df1cd2a7c55ea689f66"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93cd99c708c46f79fc0430ff7e948cc41c96921b3192a4335988cb6b1e60e4dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "62bcd19893e69fb1cd08c5b96fbf8a7016df9140174bd6cd4ee9753148c9924b"
    sha256 cellar: :any_skip_relocation, catalina:      "6fa120604d86000ac9407f29c8f242512917d0f4c15253d6f8fa0635ae9b4aaf"
    sha256 cellar: :any_skip_relocation, mojave:        "c14d9582a6180b04cc2f2a60c39b7b563d67b5b5f595c915ca215b6ee581bd1c"
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
