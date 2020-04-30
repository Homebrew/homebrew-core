require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.36.1.tgz"
  sha256 "ac94bf120c4a09c37fd1851a0a58a2bb0d21bdc5e90ddc8bf4d904185f0bb31f"

  bottle do
    cellar :any_skip_relocation
    sha256 "130d4a0e534d449fa6a980f91590b79f3d8f95cf522343e2d087dafd5e1fb620" => :catalina
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
