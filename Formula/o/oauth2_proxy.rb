class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.9.0.tar.gz"
  sha256 "a9c5884c1366d7597a42cdcea9b3c16778d4866fb3bfee3077ec4b8cdd95443f"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6917ee41aa37f9c2be286d42366a8f2d098064dbb114a116395682be1a09d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b0dd5e6fecea930baf695257d4e6bb067d602d20dd93fec4941804e501a69ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21e18c0a40289d7850f9eb4ec31a724bdcf1fe6366d602f3bd84dad14b6753b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "be6c51e0f49d011ba9bf4fb927ca455b995ab87cf58210705ab6351f9d70b177"
    sha256 cellar: :any_skip_relocation, ventura:       "c6e16d7025e6caf1fc1655f1cea4806868f027aa7850311b1d6f6275e6fe52b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c0782f2a35e85a6b1ef8519f5cbd584268b05a95c93ff9c2ab588619efcd226"
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
