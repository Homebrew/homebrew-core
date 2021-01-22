require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.86.0.tgz"
  sha256 "3825ef860613873c6a538fe913090774bae2e1b927f4df3c8d44bda58577a54c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3e2b9653b5395879af4b5e3cb3889b2c96d08bc399b1cb4964cd2c886b620766" => :big_sur
    sha256 "7004fd78e12ffa5a427c01c6b39f563c7c987bc5bb2d47c2c426cf9d2831cba0" => :arm64_big_sur
    sha256 "4c0ab57754166d1486be293779045fd658b20d3206d23a693df06397d20e178d" => :catalina
    sha256 "4703db78db2c3b34651da3ed2a9a84b5ac8a8c9c47be089ee227d1d898260dfc" => :mojave
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
