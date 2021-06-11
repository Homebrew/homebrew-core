require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.31.tgz"
  sha256 "a83d170356e04efefa19d01bcf69212a0d37babffa31093f7544b34077325c2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0900dd0d99936253c80bb9c5660d1c400c0bc2bfbc8b9e461c8b2b1ad6780fb2"
    sha256 cellar: :any_skip_relocation, big_sur:       "fcc9b31b40c70ddd1e6bbaf2941cbaf8a68978e6f029005c9bb278f5e1625a0b"
    sha256 cellar: :any_skip_relocation, catalina:      "fcc9b31b40c70ddd1e6bbaf2941cbaf8a68978e6f029005c9bb278f5e1625a0b"
    sha256 cellar: :any_skip_relocation, mojave:        "fcc9b31b40c70ddd1e6bbaf2941cbaf8a68978e6f029005c9bb278f5e1625a0b"
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
