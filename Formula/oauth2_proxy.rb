class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v7.2.0.tar.gz"
  sha256 "2e1d15083902137c7939dea235ec72fc2cc818de8af540302a2ca66cdabdf4e6"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d80ccdedcd39fef312774b9fb03a38f1620a5e8785c52e996a285ca38b2bf5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4711f05aad5403a07683f1506548c2dcbd120de9fe7d7dbd272633e2a46e97b2"
    sha256 cellar: :any_skip_relocation, monterey:       "4fad35aa9831749fa67d830806d4970023cd2efe916657a85422e8dcd41d53ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6a4c2f5dc2196c0b2a110bef21e717b5073d258409e52ef5f98271c8728d44d"
    sha256 cellar: :any_skip_relocation, catalina:       "0d98e96bbbd926774ae07441f115732755d2d871897d371af0e1a1df9e6c6a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03d8171193bae05af58e33086db444f92ec829038a3c3750a7d5a7dea211fc92"
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
