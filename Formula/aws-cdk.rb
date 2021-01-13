require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.84.0.tgz"
  sha256 "690fd4490a8a7f4b3a894de444d63208b1a07fb70f302c1fdccd5f96143aee86"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bff7dd94cf12e57916f52eccf7488a63b5d0e25dfb8894aa9a09942e0a8e6672" => :big_sur
    sha256 "369648d1c4da6967ec3819d442c8f0e80f23254bd4dc9a346d53e2b181f9cade" => :arm64_big_sur
    sha256 "fd9e2ab4780fb21387f6054bb92e22a5e1df7b63efff578a7c888da60dd2781b" => :catalina
    sha256 "4b54a9e2c3d188f59cc9e0404b6b18d9775318cd28c8ad066978500b989822ec" => :mojave
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
