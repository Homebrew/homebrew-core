require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.13.1.tgz"
  sha256 "21af9a6e91c6192912a5c951e547ee77932b3b31136dd73fd633cad7f1f7646b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d903e726387e50106a8ad5544224f86be43dc516c5a1f99718bf95bc01bbcff" => :catalina
    sha256 "3feacbd5cccecb10c3d14c07872b687f17a6a2b2aa67255bca961de02b29d6f6" => :mojave
    sha256 "6e50dbab7374ea67bc6640bbb7e8a599055f68a6964e5f9f3fdb618cccb647d8" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
