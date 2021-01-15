require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.85.0.tgz"
  sha256 "5d693718d2d491d0c9f4071c956cfc87ecf53a7f308bfdbd9aaacef224d1c4d8"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ff54f3ca0bf46ea40fd33b10fe9caef30006104b0e3bb66541c95ffe6e6a7f17" => :big_sur
    sha256 "81182aaab8d0fae5deb260d50832b89b4bd0153d6516d6e8eafb0f38f16647ae" => :arm64_big_sur
    sha256 "6f54eb3636e922195b088b6e46c72679008ec2073e616a62120e016c3b179951" => :catalina
    sha256 "51edf3c1d1e0a1a6c81348b57621f0125a926194b6bad4dfec7b5444ff7c4db4" => :mojave
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
