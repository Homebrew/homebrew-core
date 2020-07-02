require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.49.0.tgz"
  sha256 "61f9397956520cc0848cce05e6d785389585e5f5180e49116186f0df40548fb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "52ef6ab741ea4e270abc1155c7f95b58a1d3594ba5df549579ea29000ef82724" => :catalina
    sha256 "6af3b63eaeb54c373ad17909a59f8f3f69c24cc8ad3c422150cd9151798cc20e" => :mojave
    sha256 "7005b4f20ad0e0ae4570f133e31990512f100466d961be3f899ab12ed9eefaf9" => :high_sierra
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
