require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.7.tgz"
  sha256 "f6f217e2f8d6ea31668d5a3616d25848b29f2af1ecb166c372e86d396e50568d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a136f229541c98a9f204b7518dbcaa604d0f075f6f6b9eb7af5605f270fb97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a136f229541c98a9f204b7518dbcaa604d0f075f6f6b9eb7af5605f270fb97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a136f229541c98a9f204b7518dbcaa604d0f075f6f6b9eb7af5605f270fb97"
    sha256 cellar: :any_skip_relocation, ventura:        "13dd043dfe083d7dbdecd46c84024d5e2467ffea6bc2d20d4c90e5bfa9c4982a"
    sha256 cellar: :any_skip_relocation, monterey:       "13dd043dfe083d7dbdecd46c84024d5e2467ffea6bc2d20d4c90e5bfa9c4982a"
    sha256 cellar: :any_skip_relocation, big_sur:        "13dd043dfe083d7dbdecd46c84024d5e2467ffea6bc2d20d4c90e5bfa9c4982a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a136f229541c98a9f204b7518dbcaa604d0f075f6f6b9eb7af5605f270fb97"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
