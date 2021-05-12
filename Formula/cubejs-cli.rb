require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.10.tgz"
  sha256 "876d6125cc7da714eef05d4d278100d930c6885686df682a177edae20dddcdfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b01131f45156f21aec4ec4ffb66d19d57bad160bb92cf05e2a752f0f59057636"
    sha256 cellar: :any_skip_relocation, big_sur:       "97a1d4ce0a8d050d798c16ee7467a4ef3ec9a3cd7016ba77d3a0281bab405ce5"
    sha256 cellar: :any_skip_relocation, catalina:      "97a1d4ce0a8d050d798c16ee7467a4ef3ec9a3cd7016ba77d3a0281bab405ce5"
    sha256 cellar: :any_skip_relocation, mojave:        "97a1d4ce0a8d050d798c16ee7467a4ef3ec9a3cd7016ba77d3a0281bab405ce5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
