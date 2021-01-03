require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.82.0.tgz"
  sha256 "fc355550d098c6c36c6cdaa0135fb26bd96ad2b3978aa713b07eb21bc12059c4"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6ab4792f40c317c850b2cc474bbd17fb2fbb994fd7eea1d351d21b38065b0053" => :big_sur
    sha256 "bb50f617dbd83fea6492f8b2de99bc990e679195519a1a69b769fece568cfc66" => :arm64_big_sur
    sha256 "9cb667f27e756e4b3e8c2a4c00b166703d545955f01f269af29c9a5366c4eb94" => :catalina
    sha256 "b494521a3cb2102579b5c14daa5f8d8165f725b9f8995495d2e7e84a2fee6eb6" => :mojave
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
