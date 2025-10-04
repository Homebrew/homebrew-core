class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1029.4.tgz"
  sha256 "6ff76f6d7284c17d77a138bb8e38d5e0bed33a30030cd2d110571dccddd4aaf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b3a6eb07a68978525e4cdcbb8f1227b36e85d77cea600eef9e90eaa39b620d2"
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
