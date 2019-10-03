require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.11.0.tgz"
  sha256 "94f05275bfb34c521f0db7c4f346d2be1e4746e919dc7d3dd6ee2d56a92396f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7eae59f56fc0cca3e957a68cd98b44e79deefdba48505c6a93707983924f546" => :catalina
    sha256 "2e5f01a43a191518334f873801a7c6a4049b4882080afbae1b969a3bd64996f2" => :mojave
    sha256 "92089915fb857e667f96e9ac3303dd306dc7148330c67f3c5658613490a38a2b" => :high_sierra
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
