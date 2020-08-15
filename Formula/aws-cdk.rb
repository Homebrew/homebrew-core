require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.59.0.tgz"
  sha256 "18664992efccda51e45f04bdee445570a4d2c21aa7d1a9172604d3bfe3d96fe0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "212e9d923ae8202b3835fd53dec1ce875a808b56b8ac7fc61de456dd4b8cf9f7" => :catalina
    sha256 "e44cdcc7e9c44d28031a85673e7b27af11bb55a5cef7b9ef5aa46a6adb6e63e9" => :mojave
    sha256 "b85ed0b850eb0022e5e94933aaee75a8cd404e82b854a2de846e4b8f47b6c6fa" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
