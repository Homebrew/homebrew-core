class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1148.1.tgz"
  sha256 "01b5e99ce9b096cec11f19369c4b3ba0aeea0d9000c7824014deffafe92a4c86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8493b79ad25033dd456eee741d1ae596c7262952a0f258192122a83e400a7c15"
  end

  depends_on "node"

  allow_network_access! :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
