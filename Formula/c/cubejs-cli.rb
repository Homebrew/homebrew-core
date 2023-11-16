require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.22.tgz"
  sha256 "336c1843c51176bfa09880b5c9d2b2459603240a891b91082319690588ed50bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6a32f6487f2bea56017d3988767a72931f76eebee99603ed7febf1a6a7275611"
    sha256 cellar: :any, arm64_ventura:  "6a32f6487f2bea56017d3988767a72931f76eebee99603ed7febf1a6a7275611"
    sha256 cellar: :any, arm64_monterey: "6a32f6487f2bea56017d3988767a72931f76eebee99603ed7febf1a6a7275611"
    sha256 cellar: :any, sonoma:         "35e20a52df1541ebba280764675919a880b7e923f2f547f35895f82d33a407c1"
    sha256 cellar: :any, ventura:        "35e20a52df1541ebba280764675919a880b7e923f2f547f35895f82d33a407c1"
    sha256 cellar: :any, monterey:       "35e20a52df1541ebba280764675919a880b7e923f2f547f35895f82d33a407c1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
