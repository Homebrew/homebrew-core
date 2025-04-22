class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-14.1.1.tgz"
  sha256 "9e1ceb265d09a4d86dcf509cb4ba6dcd2e03254b1d13030198766fe3897fd7a5"
  license "MIT"
  head "https://github.com/http-party/http-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bb1d84d1666919ec7a065dbb8d7a33a6b66ec0d853566efb9fbef8257202c827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8798ac5ea1972bc153b971db14968ada2527c73c4ac4c442f3c3e2c2d2b0802"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8798ac5ea1972bc153b971db14968ada2527c73c4ac4c442f3c3e2c2d2b0802"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8798ac5ea1972bc153b971db14968ada2527c73c4ac4c442f3c3e2c2d2b0802"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8798ac5ea1972bc153b971db14968ada2527c73c4ac4c442f3c3e2c2d2b0802"
    sha256 cellar: :any_skip_relocation, ventura:        "b8798ac5ea1972bc153b971db14968ada2527c73c4ac4c442f3c3e2c2d2b0802"
    sha256 cellar: :any_skip_relocation, monterey:       "b8798ac5ea1972bc153b971db14968ada2527c73c4ac4c442f3c3e2c2d2b0802"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aef704031b11e99b66edc4bd3807d1ea4b4c365582ae6d5d6b669303e2368332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9f714a6e9f2aae98529f5cf3c01587a9c3ff867ad8aa8446453a62688ff4bb4"
  end

  depends_on "node"

  conflicts_with "http-server-rs", because: "both install a `http-server` binary"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    pid = fork do
      exec bin/"http-server", "-p#{port}"
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "200 OK", output
  ensure
    Process.kill("HUP", pid)
  end
end
