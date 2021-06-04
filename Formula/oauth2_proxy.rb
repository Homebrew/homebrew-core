class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.1.3.tar.gz"
  sha256 "b6d45f3b44a98002ce8f3b581ffd79ade33fb19f374093df43564464439257ad"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9d950a65f353b4a1a5dc50dfc14787563da71e1abeebe5e1ef9ce95902a7f99"
    sha256 cellar: :any_skip_relocation, big_sur:       "b073697acb3f2d6a3a9937c97a3d70de4441c7defa84e6bfbc96b1e5108082bc"
    sha256 cellar: :any_skip_relocation, catalina:      "dc28f5a739675ce3ec65a0a543f8616db14b67873cbae476f2ca83538f3f081c"
    sha256 cellar: :any_skip_relocation, mojave:        "19281c15d78f17d6fa9c6c07196803aadac303bb551bcc30651838149c0c8fc6"
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
