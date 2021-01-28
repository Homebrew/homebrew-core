require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.87.1.tgz"
  sha256 "f4c10698b431b295c18ac046c365f5675dd99b606dd6d236022a6557d168ef9f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "111248ee1fbfb5b4d117e99a7c33e26e0c82dadc2109e38a61440af7d7d8b267" => :big_sur
    sha256 "0a86aeecfdb3e96ac8bdbd05d0021a6c9acb425330bc7502e4faf9f58778e5ae" => :arm64_big_sur
    sha256 "05108b57cb17ea59ab7e797028c22fe3c25f437867d17070f256ba0fdd682088" => :catalina
    sha256 "73da30b245db3892c9ad5fb95a50a42dff5da1bb2edc509660e73637f351323b" => :mojave
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
