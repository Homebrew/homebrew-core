require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.47.tgz"
  sha256 "79f5b778571abd41821c32ee6ae939cf0801680e695e02c16f5c66039c18e861"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8543b66bb96b36aefb8c6ceef05e78431e13a8e2f2565a078d3b04acafbcd273"
    sha256 cellar: :any,                 arm64_monterey: "7854488385a7f75cd8cdbece1e87336c7735d979155d769ca1008e08a1e2eb70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8543b66bb96b36aefb8c6ceef05e78431e13a8e2f2565a078d3b04acafbcd273"
    sha256 cellar: :any,                 ventura:        "76c7b574a104830e77618c68a33f4e8d4c13d6a11984b76e6f7c0c0ace30a999"
    sha256 cellar: :any,                 monterey:       "76c7b574a104830e77618c68a33f4e8d4c13d6a11984b76e6f7c0c0ace30a999"
    sha256 cellar: :any,                 big_sur:        "76c7b574a104830e77618c68a33f4e8d4c13d6a11984b76e6f7c0c0ace30a999"
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
