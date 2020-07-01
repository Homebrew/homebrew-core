require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.48.8.tgz"
  sha256 "11049503b2c744ee31db7710628dbfc2650b0bdb69dc948c3b1c3dc5421ad79d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d2f7cb20724118443f62dacfaf01e823ea0519b32916d1875ddb78370777fc3" => :catalina
    sha256 "57bb09b8cab78eb4ba4f8cea26f19f5de75a06c7d73d0a1c2cd30718a92eee5b" => :mojave
    sha256 "f421900eb939b2e0c592e7c41265ffc4066fa7c9c8ef8f8a4971114828ec2764" => :high_sierra
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
