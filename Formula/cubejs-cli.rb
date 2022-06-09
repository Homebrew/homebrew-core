require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.16.tgz"
  sha256 "68f1accf6d47fbf23b661c88e2dd749adfb7317aaa3387ace29a91460e4ee0ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0639d3d1b7db4b007e0b115a1ed91e2c5ecf63b3ba65187aeb21040d01b1aaa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0639d3d1b7db4b007e0b115a1ed91e2c5ecf63b3ba65187aeb21040d01b1aaa1"
    sha256 cellar: :any_skip_relocation, monterey:       "7d558a90a52f4927016a4678db7c887c45237e4434a954b6b8f6c424fe3aa337"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d558a90a52f4927016a4678db7c887c45237e4434a954b6b8f6c424fe3aa337"
    sha256 cellar: :any_skip_relocation, catalina:       "7d558a90a52f4927016a4678db7c887c45237e4434a954b6b8f6c424fe3aa337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0639d3d1b7db4b007e0b115a1ed91e2c5ecf63b3ba65187aeb21040d01b1aaa1"
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
