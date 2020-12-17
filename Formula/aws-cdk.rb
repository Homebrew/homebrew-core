require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.79.0.tgz"
  sha256 "e98f9093a1e0d32d00f5c29b5491724488681fde61c21f40cf92c0caf286e4d5"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c337d7347552a7f1aab1e39dd57d1ece1f97ded3e4e3ff5c508ef4ff4b8e39ac" => :big_sur
    sha256 "0d66c99b82a400b91a91237a29b32e0462fd28d88ba50d8bbff9e5c76aa01103" => :catalina
    sha256 "651b81d5117d286269c1669db31bbbd4ac90e60eb57035c24fde3755b035ee16" => :mojave
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
