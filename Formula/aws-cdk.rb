require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.11.0.tgz"
  sha256 "94f05275bfb34c521f0db7c4f346d2be1e4746e919dc7d3dd6ee2d56a92396f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "480fa1e3e22644a17f66258800aa0e7cd148628a63cd33967e90f7fa7ffffeb1" => :catalina
    sha256 "b1dbdb0feb9224cca465001d2353c98a2d5749f626d1451a7447ea3e879d50a5" => :mojave
    sha256 "c3cdbed60a0fb9c2e48b28c6defeb6461adb8b5a8ed21105c3c182c181df8012" => :high_sierra
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
