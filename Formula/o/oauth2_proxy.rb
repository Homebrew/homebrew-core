class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "2beac9e817d59b37f2277efefeda68447418355792a60da709a80c278628fcd8"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c37d7676bce62ee0a6e5346d810e2d243b46b7a0ba65860a31ecc68522a58c0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d555a042df67ee5bc8d5bca7c59f3107c97479f1cad35dc56feda25a939e36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33c05af537b1e4ac7211d8fd8860984766827b17441d0d95f113e2ab657b63db"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bf5231364318054cf8a5781dd63265ed83b2b3637398ba41f7e4e81965c3706"
    sha256 cellar: :any_skip_relocation, ventura:        "ce8fac9329569a0cb1be83dca9bf6b13b96893606cf1a52344c5a652a820edf2"
    sha256 cellar: :any_skip_relocation, monterey:       "982d3fe7eef4c0465446a02d97e4948f5af429f2c88ed37ab38255fd112767b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0eba1f060c2fa8237aa1b3769b2d3244aa4fdd307acb6f59fdd623024df6ee4"
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
