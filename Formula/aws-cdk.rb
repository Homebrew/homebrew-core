require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.109.0.tgz"
  sha256 "d7ee053aff22ffcf284f634cd87acefaadd4e0d06a3d746fcd470715c24301c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ad632d4eaa0b2588e71f194b796896ba216188e0490ed4e312f01b5f7e7aa03"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf6a3eb7802bedc2f691c02054cdd5a627dcb5b5460c598529973532730b734e"
    sha256 cellar: :any_skip_relocation, catalina:      "cf6a3eb7802bedc2f691c02054cdd5a627dcb5b5460c598529973532730b734e"
    sha256 cellar: :any_skip_relocation, mojave:        "cf6a3eb7802bedc2f691c02054cdd5a627dcb5b5460c598529973532730b734e"
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
