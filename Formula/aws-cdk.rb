require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.81.0.tgz"
  sha256 "52b8412b6d3ed393aaa2fb11380cb480e83734bb73a80cc876534150defa4b15"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ae37541bee64b30dabe4cbe68267345f689b20f7b850e1b3d4dad9581a6f9736" => :big_sur
    sha256 "b443891da2f6bd8133565d23cfc84ce123553d610170737b4280ec6087e1903a" => :arm64_big_sur
    sha256 "c3f2f49f2563844ed3a339797e5cd55dbed61ae8052288a9375f35a5dd0d78ad" => :catalina
    sha256 "17a71ffb6bf44f4a9bc9e551215961d0899689ec5b5938625731e7e5b7fa8f5d" => :mojave
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
