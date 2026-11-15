class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.6.tar.gz"
  sha256 "7a24bf731e10d5db9149d7186576bc1286c5d084d3a9536ebece2e53b341b8a9"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84951f5ab6a4373dc786babcd8e6987ebc0d884213c9a75125fa13b3fe56b0dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9faa7cf7e2af650ac6cacd3bb83fff5f67716ecae50b11eab5841ae806308b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddd8652dadb906e4dec5adaed9d49b2678d6c2d1b33f258a4f414e21b7ab0cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6840ee27781b1c3d8cff81b94fdb4b91d2d295d11924a01d50de46a85a819a4"
    sha256 cellar: :any,                 x86_64_linux:      "809e44bebf0e82ed3fc24ac66defdcf6ae90bd314d61ba3d723a971d727ce91f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"oauth2-proxy")
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
    assert_match version.to_s, shell_output("#{bin}/oauth2-proxy --version")

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
