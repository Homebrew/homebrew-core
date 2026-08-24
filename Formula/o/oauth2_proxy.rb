class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2-proxy/archive/refs/tags/v7.15.4.tar.gz"
  sha256 "52e46276359e8e06cc53e9636f605784b9d6f21819c2592d07f9cf5c1eb78779"
  license "MIT"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ee307e2f05a71c12e3e7bb5fa7db5f909c81405f420dd1af64cd86765b8899c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d5d69bd021ca707f9ffae951d8d654dd507bcf50987a32df8258b15f44e900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49cbec534a65a6a184ab1a92759c567bb65dd200836e47d934b307d9a32692ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fe0956296d32e82dc037cf77a0814c3b729db55d64da747f65974a17dc403a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c9c0eea89a8290ff52dd268d75dddfe58da50a404b9dd80f2fec34beac066b3"
    sha256 cellar: :any,                 x86_64_linux:  "7ffd275109ba2eaf2961a059714b709842c72426bf0c4d46e5e8028a43e554e6"
  end

  depends_on "go" => :build

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
