require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.14.tgz"
  sha256 "7523625e46ac5c354cd83ad09970244ed76e2aa7b17fe140ca3b89b76cdb7e00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b253a81f2fda79a2c37575cc5c97196b1e83f2fae59b01d1fcc5a52c7b286106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b253a81f2fda79a2c37575cc5c97196b1e83f2fae59b01d1fcc5a52c7b286106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b253a81f2fda79a2c37575cc5c97196b1e83f2fae59b01d1fcc5a52c7b286106"
    sha256 cellar: :any_skip_relocation, ventura:        "2cc1b1560cbce4bfed8bcbf82bdd152eeda50b78fe243ee92fc1de99f84c2945"
    sha256 cellar: :any_skip_relocation, monterey:       "2cc1b1560cbce4bfed8bcbf82bdd152eeda50b78fe243ee92fc1de99f84c2945"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cc1b1560cbce4bfed8bcbf82bdd152eeda50b78fe243ee92fc1de99f84c2945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b253a81f2fda79a2c37575cc5c97196b1e83f2fae59b01d1fcc5a52c7b286106"
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
