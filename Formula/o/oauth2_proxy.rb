class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.1.tar.gz"
  sha256 "f078bb88113a1ca1d1430f5bfaa47e0e32a04ac18f1f5bac7645ff45d8222e0f"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e4918c0a2079191785e5978060f8499110e27b2edebbaba15b66303a1ab9a27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7666b4ce362efa3e423cbc171f7a84429db58759861095212cb7fb4b54f9549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91141f9145a8818364859c690fad2a08d44334b85508a72023b9aee26a1bc1b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "29fe24393ac853efaddbd9cbc22ccd3dcf18640a8fd6e5eea01080a6828ccb00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cc994982a4b924aa1639a8fcb343d3a4620fb972ab72be96a6bcb282405b2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45f803b7e75339671963cdccd0191419b586b8b558058e2230633576d7924e1"
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
