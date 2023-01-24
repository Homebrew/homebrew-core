require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.52.tgz"
  sha256 "dd30e7288e958d1f94eb9d4ce2759f1379cf4e4d9794a077137cb49af237964c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dca134697202842d2d954fe1cd378c8d01706210f0f341b55fae570c98d5fa74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dca134697202842d2d954fe1cd378c8d01706210f0f341b55fae570c98d5fa74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dca134697202842d2d954fe1cd378c8d01706210f0f341b55fae570c98d5fa74"
    sha256 cellar: :any_skip_relocation, ventura:        "20d6d68dcaf32de74b2aeba4c62b348ec938895f067c888ad49d09a756f1bfdb"
    sha256 cellar: :any_skip_relocation, monterey:       "20d6d68dcaf32de74b2aeba4c62b348ec938895f067c888ad49d09a756f1bfdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d6d68dcaf32de74b2aeba4c62b348ec938895f067c888ad49d09a756f1bfdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca134697202842d2d954fe1cd378c8d01706210f0f341b55fae570c98d5fa74"
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
