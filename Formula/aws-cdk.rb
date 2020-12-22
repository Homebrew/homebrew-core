require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.80.0.tgz"
  sha256 "e125a15950915ec48c447ba5e8bce69733de83bd735a55dc22d942386f0fc25f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "14663b48702923d61bf4fd0a2458a1ce386d54e2aa1577b11ea0dece61e6baab" => :big_sur
    sha256 "0e63fc97d9c2b5d75838d8f04b75aa58ab3167d2d79b34c3f49cadeb26aa46c6" => :catalina
    sha256 "12c903ec3decff019b99a016e78a05ad478bdbc99373fd100cfd3e287c323536" => :mojave
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
