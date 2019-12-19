require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.19.0.tgz"
  sha256 "3f0888a86901baefda9bb952a1f09a4ba29c3b2c512fc5860f6ecc8e90724557"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f6a234a777d4563a3b5a6fe98ff05b3284fd272a089f78b322e80cf293d9b68" => :catalina
    sha256 "d2dfd62dc0d0daef17b0123159c18c11ecd0cbfe2dcd4ee12ae15d51230305c1" => :mojave
    sha256 "523a01a30f367e0811b2ae884e2b93469d6f72b05c5c2a887cd1332a709b0222" => :high_sierra
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
