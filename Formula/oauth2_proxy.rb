class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.3.0.tar.gz"
  sha256 "a7f4d087eef75dbc4e3b1d5df8cccbfdf3adced577bf72350bcba2c5ef8f4144"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9cba89eddab57dd20217411d6f2809c3248601b5464a7646b4b8d2dc730f66a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b13f716b9da407692ef38082ba829b0e0fd60fa4c0e0c44077ef401dfecba6e1"
    sha256 cellar: :any_skip_relocation, monterey:       "2f4dc0e4f0d79b052682d73b6635b629ed7331199ed6feec3558814b92ff1d45"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cdf5fc8e6f16ee54892ad9bb2139548b621b5449e20742594d74a876b30ce13"
    sha256 cellar: :any_skip_relocation, catalina:       "d44b06c7ff0a3c356d6234a864bb57e09dc4cbe6c74139a4ef956864188a573d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06920e7d165fbded5e81a60e915e286fb74bed4268275988273329e826b38275"
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
