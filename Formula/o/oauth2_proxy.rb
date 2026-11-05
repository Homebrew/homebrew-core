class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.6.tar.gz"
  sha256 "7a24bf731e10d5db9149d7186576bc1286c5d084d3a9536ebece2e53b341b8a9"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15ce14d5e75a072f73315d89fba36361c4e786907e73c9de81030473bc424401"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76d6c2819ebce530cb5a698e5e36412c15e421f72ef5ce68e97352c2dda96d16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86983352e8a449291a694c502bb30c532914c1169acd37af8134704b23507717"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16462094aa070b585b4c6603a1628b8e3a5e59f6b2d5368b054cb5e5014db39d"
    sha256 cellar: :any,                 x86_64_linux:      "173429be3e5962b95e0dfbf86671bbfaac580df84a7e41c858b66d97b74105a7"
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
