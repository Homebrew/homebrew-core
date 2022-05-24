class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.2.1.tar.gz"
  sha256 "fbbb1581582c1a5655272070599f1739f919add79836027f34b366939c250273"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f00f9796332a7a1041eb7b2ea657adfe3a8d641d67d0e9c3b23d3424eafaaa51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90c207c6ff2e012401f5f4a398995bcf3bb28bcbca21e4c0ea81cc96795a9f1"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc77b0e1661a5d180ace6d58f40d6689b8b79a043400accec71201192acdb16"
    sha256 cellar: :any_skip_relocation, big_sur:        "f62725c2c098efe81d8dc6a7c4f118de6c5de40a40d1f1c7a86b445b7ed9812d"
    sha256 cellar: :any_skip_relocation, catalina:       "0379680d1777c22ee01d14479384d8936e1a31521b970a6d9fa751f88b8a1dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db5e176df7fbe4f2032e2e2e5bc3a1f546977880ecf5fdf12d9e6e8eda7085d"
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

  service do
    run [opt_bin/"oauth2-proxy", "--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
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
