class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.3.tar.gz"
  sha256 "a13491bfd083e570d451275458728fb3f722b4d46657644df1ea90c676c552da"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3e57724364d8abe176be071fd1db4ada95b7cb1ebfc5215a1aea01bf8403b74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94fef41e66d2bae51e1036cd0ba7df2fae2f95edd1833657f5be17a955f77ee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba0fdcf5eb565dd4b1003baa0ecb3a9bdb88dba2036a210c633af6875b55e7b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f153ac1a4e45cb51c6a05e84c22ac01bef150595d75c30ef042f9500f9623be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68f6e99c7b580cf658c3f6f24911d338c17ecf5022fa4e228631e4b41ef7233"
    sha256 cellar: :any,                 x86_64_linux:  "1156b7631214febe4f7f3f92e90cc1e1a5f5588db76d468f559fae21a50471bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=#{version}"
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
