class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.1.3.tar.gz"
  sha256 "b6d45f3b44a98002ce8f3b581ffd79ade33fb19f374093df43564464439257ad"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30e32e8b0b482dfd924fbabc8eb909e91afd46340f2c446fa779edd44c697ebb"
    sha256 cellar: :any_skip_relocation, big_sur:       "070c01170bb8b590d5b4d2d058a6dc20305dd6d00d1aa0691cecf4d55a8902be"
    sha256 cellar: :any_skip_relocation, catalina:      "36d3b76fe43e2c2756578afffacfb6f9b718f446020502fd9d108a46f948c9ab"
    sha256 cellar: :any_skip_relocation, mojave:        "c4913f7f9acb77035f20c565da9cfb6011cb252101bda0ebd1ce8cc231766206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c840654a0a4378635e17f3bb4f39dfcb9f0d39ea747d91cab20b243f94bd48"
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
