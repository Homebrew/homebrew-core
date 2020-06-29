require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.26.0.tgz"
  sha256 "d4cd0eca893011420765bea1aed6a198a1f21b09d9650223dac33c17ed5eb4fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbe959a51ea974ef1cb5ba1b5e63269c14905b2b9ca6975b17a4c9370c6287c0" => :catalina
    sha256 "40e4cdd6c1ed58d815b6685f7df0a57a9156209bd4460d604af16cdbdc2bdae3" => :mojave
    sha256 "c5638765608a604e0a7974a145bc49f665f210afaf50588ec5924708e26e3286" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/cdk8s", "import", "k8s", "-l", "python"
    assert_predicate testpath/"imports/k8s", :exist?, "cdk8s import did not work"
  end
end
