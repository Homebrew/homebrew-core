class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.4.0.tar.gz"
  sha256 "f9c5791537b1286b5985b0123f19ad84d390a7fffc1edc1b7c50c5d66c67ebdd"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2deab940416c36a506300ce0a03d047169212327b2bb658a5119469ee5f983d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1813499b6d63547f16af1b40833a8f8cb95053f6b04e67f2a3f5b86533e0debc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8de92ac8df98b26aadfe3ab97025d61285d57cf40d4509a1559fab6475803270"
    sha256 cellar: :any_skip_relocation, ventura:        "64d6ff728f148317e71607a49c090f28bfb343cbf2d66161a114e0d7e2509a83"
    sha256 cellar: :any_skip_relocation, monterey:       "0af00d421c7605c8199bc1a9c0e5482d14db98608fff1b4f2413b1742911e546"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdee9a9322baf39ec39ace1c84166946bb1f9b2f1330a01356486783b851a11f"
    sha256 cellar: :any_skip_relocation, catalina:       "d8e4cc0cfdaf43bbfda3ae3144e1ec0a8bad83f5bd07082cf8a8d30eb4eb1c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50775f653494005e9d967fa5fa26c97983e3b28886989526bb092b76cf63486"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"oauth2-proxy")
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
