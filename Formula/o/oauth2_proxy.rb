class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.2.tar.gz"
  sha256 "1c5687373ac84126ab506c505377c9486e0d1aba2ebc80fafb4e8f6717337a21"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26d651e47b752ceb4b6411376d6a322a04f10be3bc94701b76f5f2aef5fe338b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe0548af0ac88a37b9d745aef089f9930302ccd148f295e8efb8b31ae26521d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcce4e3d122777aa3e41e68db110103bbfbe19f029c33fbb484e12eb8671c26f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f56fac995536a7b3ecb5f3942f5a18da8d4288bbd343a9af55fe7fcd5cd16b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e24e2d572886af4ba6edbd07f78fcc449d62c7214bbb0cb97128138bd336dbcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba55f0f2d6a2a646968f78673c7417aa03ac2b7ae516246512b6ffa2cc7dfb8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"oauth2-proxy")
    (etc/"oauth2-proxy").install "contrib/oauth2-proxy.cfg.example"
    bash_completion.install "contrib/oauth2-proxy_autocomplete.sh" => "oauth2-proxy"
  end

  def caveats
    "#{etc}/oauth2-proxy/oauth2-proxy.cfg must be filled in."
  end

  service do
    run [opt_bin/"oauth2-proxy", "--config=#{etc}/oauth2-proxy/oauth2-proxy.cfg"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    port = free_port
    pid = spawn "#{bin}/oauth2-proxy",
                "--client-id=testing",
                "--client-secret=testing",
                # Cookie secret must be 16, 24, or 32 bytes to create an AES cipher
                "--cookie-secret=0b425616d665d89fb6ee917b7122b5bf",
                "--http-address=127.0.0.1:#{port}",
                "--upstream=file:///tmp",
                "--email-domain=*"

    begin
      output = shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
      assert_match "<title>Sign In</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
