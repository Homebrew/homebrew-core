require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.1.tgz"
  sha256 "894bd07b0c342e40777370ee5713bfcc6a9727533bd41d5589b67e50ed5f41cd"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d0fb14e93c135d52db088ee43835385580c986691df7fd02db8d548b68cf2860" => :big_sur
    sha256 "bffed39528005782a56d91d23c74784f5489b6aa359cc7716fcf7e1592170496" => :catalina
    sha256 "8e3c92371bd0b5ebf36efea25fafd90b78d7cb03949aefbcf26c4cdd5957d01a" => :mojave
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
