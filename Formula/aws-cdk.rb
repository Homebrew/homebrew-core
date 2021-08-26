require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.120.0.tgz"
  sha256 "fd8096e6f54249360a809f28df12ec3584ad753516b7cf40252503a4c61cd3f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "079f8c46e0190795133add90929a5fb5bfd58db0a43bc240f57911eaaa65762f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cf84b5dcc7b2d0349520161dd7c79f2b9e195bf62588e9345d6fb4121b7257f"
    sha256 cellar: :any_skip_relocation, catalina:      "6cf84b5dcc7b2d0349520161dd7c79f2b9e195bf62588e9345d6fb4121b7257f"
    sha256 cellar: :any_skip_relocation, mojave:        "6cf84b5dcc7b2d0349520161dd7c79f2b9e195bf62588e9345d6fb4121b7257f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "079f8c46e0190795133add90929a5fb5bfd58db0a43bc240f57911eaaa65762f"
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
