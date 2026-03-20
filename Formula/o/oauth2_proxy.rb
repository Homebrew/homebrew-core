class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.0.tar.gz"
  sha256 "9f1e4f1635e9cec604969bcd24f6a37755330f605986da8f72d6c47a43970fc6"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dd3ddb38a6c0658d309b0de623f34fd5169323df7d8743802e6a5c6650eb3fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f92ac304a30df0d2790d1b42a66276d1bd1082ccca9bf478dd090344da4a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a08b92e231f1c57218ec909fbcd2e4f799875f679d90810d6450f07c06fba03"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ec3ce44ec017cc95ce777b910e35d1f410710f1a622e8ede616b641781237cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a5efa1273df07284d12343bd4fe7d14ab9df2584037c7a2aacdab59b4ce505f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f97bd9080ac34305c11455820787cf69c635153b9119256ad6d613c18caf98d"
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
