require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.22.tgz"
  sha256 "a831658b946ba4b5ba9cf6f7ef7dacdc1fee0e11a93d88f8e84cc05df9d3f8f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
    sha256 cellar: :any_skip_relocation, ventura:        "cf9eabcd17200d6aebc62106436121cc1753299ced20318daae0ee6d434d6bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9eabcd17200d6aebc62106436121cc1753299ced20318daae0ee6d434d6bc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf9eabcd17200d6aebc62106436121cc1753299ced20318daae0ee6d434d6bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc0713daf75cadbea7a8f0eeca3f6846f7a729f00d4578b15a5a5e16daa4d6a"
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
