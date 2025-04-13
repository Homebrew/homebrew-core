class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.8.2.tar.gz"
  sha256 "96f23df77e6b31425579edb631492e9fe3a014bb296c5a261eeb6b9ada5c7787"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229d5cd89ad4b6d458364ac131f23c75919bf11e57a9ec67a438b6c3f5ef39ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2e416079de347fda2afc806783b4730c895c3ca94e9e39d332334337f138985"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "389980ef311594c69aebd52344e85f5f4397db6428c5c496e84e3e243a2d46fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6cb43cf4331002a499df942ef6d4c52202ccc3c3d375f66cca7f9fed1fd5f75"
    sha256 cellar: :any_skip_relocation, ventura:       "b58beb6f2253a9181aa84bc8cbbd3a669066d2f711419d2a91e450482c0d484e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d736ff70cfec44232435520a39996a971f02e15c766bc5017f5e2a8a593ae2"
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
