require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.49.0.tgz"
  sha256 "61f9397956520cc0848cce05e6d785389585e5f5180e49116186f0df40548fb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f2ba97521f447223fa55e4ef37a134414f1ee9b562951e1dc752b54dba924f5" => :catalina
    sha256 "28d7b71512b604cd0fff267b1e4a1bf3da70045241b84ec65eea959900a34728" => :mojave
    sha256 "047aed5fdb0d9a941b4326ea686e44ca409588488c650b24587148fb2374069a" => :high_sierra
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
