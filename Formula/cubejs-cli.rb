require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.61.tgz"
  sha256 "9ddbbf2d4c22e4265c446d10f081072c248ce292afbf1261f61d8a0e6068aa66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56a038c17f82f64fcae1a7bf11dcfdc2c6eaedb3833fe220456d131b3cd6fa54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56a038c17f82f64fcae1a7bf11dcfdc2c6eaedb3833fe220456d131b3cd6fa54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56a038c17f82f64fcae1a7bf11dcfdc2c6eaedb3833fe220456d131b3cd6fa54"
    sha256 cellar: :any_skip_relocation, ventura:        "f19b00296e7d35dc4e24d517f5c61741ecace18602e8a83029a2d19cef406bd0"
    sha256 cellar: :any_skip_relocation, monterey:       "f19b00296e7d35dc4e24d517f5c61741ecace18602e8a83029a2d19cef406bd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f19b00296e7d35dc4e24d517f5c61741ecace18602e8a83029a2d19cef406bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a038c17f82f64fcae1a7bf11dcfdc2c6eaedb3833fe220456d131b3cd6fa54"
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
