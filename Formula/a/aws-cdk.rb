class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1028.0.tgz"
  sha256 "4dea8f637f89fdaf243283beeb73f3c54a276e1c6a6ae244f5b2db65e295e475"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40c7eabbd901261e51de9bf09001ad10e30a8b3b79fc97c270c002e9740a4436"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
