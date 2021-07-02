require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.111.0.tgz"
  sha256 "5d24fec2911af1aa5125f538a71167207ba63c651b640ca4745f3ec86b26f02f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5dcc5094ebc88e87312088869de569e4b37536b9d11e3109d64f0d2e6d75b4c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "0082485affcf999f4b2357e982ceffd2e580736c75d8ca910dd724955873a60b"
    sha256 cellar: :any_skip_relocation, catalina:      "0082485affcf999f4b2357e982ceffd2e580736c75d8ca910dd724955873a60b"
    sha256 cellar: :any_skip_relocation, mojave:        "0082485affcf999f4b2357e982ceffd2e580736c75d8ca910dd724955873a60b"
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
