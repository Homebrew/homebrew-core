class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.3.tar.gz"
  sha256 "a13491bfd083e570d451275458728fb3f722b4d46657644df1ea90c676c552da"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dee50cf5537e1d4b73df7a6244df85d0101cadc1ac1ebe8cd7f73d5a0dede70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d8239aa520df5ce11719d7156f9bc2fb75b19d76865ca15103c96e82c1e9a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4daa5b9e2a95c8425bc096938e601668e885dff79fd8e9030d71c8996cb62f11"
    sha256 cellar: :any_skip_relocation, sonoma:        "e59d2bb5520dc6785d8751f9d92d59c2e270b38180f714c47b12f5cf3339f9e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "766e911a1c4128d093821ba121fc137a0f3e3a94514f672f6917054adecc343a"
    sha256 cellar: :any,                 x86_64_linux:  "adceb3ed41724bbee87692cd0888eef3ebc861c285d2c131ce75fcadb6496c66"
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
