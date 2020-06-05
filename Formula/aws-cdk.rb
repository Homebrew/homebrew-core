require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.44.0.tgz"
  sha256 "cee34b741a3aee4b4b2a01073c52cdc7d23404db00b05511265d40033eb672e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f6bc0d62262b70d9fd7119a4048b657daa499add814e1bfd7ce1f7e6842abd8" => :catalina
    sha256 "d3903e220de8fe720aa0eceea34c4a91c19d7abf456472a06b38b2418d607adc" => :mojave
    sha256 "cd075979fffde9a2b9fa771cce60278e083e421c5da52616bb8095b7f9e4817d" => :high_sierra
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
