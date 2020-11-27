require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.0.tgz"
  sha256 "2ce07bdc4c4ab84dc5620e13536694a45340f267a7fffc5b1f6df24c9994cec6"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "506ce943cbe5f610ff593e7784d6a97dd042d2ef72153fb2005801949bb3ba74" => :big_sur
    sha256 "cd9f65f8b88a83034bc7a4b327365e0012941b3e37efc7657712d31043b43d41" => :catalina
    sha256 "ae479290e0ba11a0e16166fb631af0261a20543f8341db887c705cfe150b5825" => :mojave
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
