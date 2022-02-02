require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.24.tgz"
  sha256 "4c95b71517d2cbe32038a444d140f107deeec9628ab4c05a54c30330a5d901b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15476969adccc2de0f0eb73b91227408ca7aaca4b7bef1354bf8859dbfd06971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15476969adccc2de0f0eb73b91227408ca7aaca4b7bef1354bf8859dbfd06971"
    sha256 cellar: :any_skip_relocation, monterey:       "774bba6a38faf706641f1fdcae0319daac9afb37a3ca079fb6c54d5c6003c72a"
    sha256 cellar: :any_skip_relocation, big_sur:        "774bba6a38faf706641f1fdcae0319daac9afb37a3ca079fb6c54d5c6003c72a"
    sha256 cellar: :any_skip_relocation, catalina:       "774bba6a38faf706641f1fdcae0319daac9afb37a3ca079fb6c54d5c6003c72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15476969adccc2de0f0eb73b91227408ca7aaca4b7bef1354bf8859dbfd06971"
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
