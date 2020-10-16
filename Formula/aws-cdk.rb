require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.68.0.tgz"
  sha256 "74cf98b74897fd9df82a1f6ca25884cdc04a6c473214cc33a0ef99c1d2dcad10"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f33beae6c47fc8906b7211e1786212c32ee0050c5c3752f7073a0d76fa9773fe" => :catalina
    sha256 "367ae4ad8944008ede98eff0777874ab625dcea1bd952f2fc1c881e42869e49c" => :mojave
    sha256 "6515267a72349cd1077eb26139661d99da593f25d9061ed1c2a9991b08f5a500" => :high_sierra
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
