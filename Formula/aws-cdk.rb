require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.127.0.tgz"
  sha256 "02d40cd30cd3b7758b41a949628928843e309eb23337529efb63a9889d81d8d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e1e1d349b6067949f9a444b150802c9f340ea2ef08f433ff696e5db2c70212c"
    sha256 cellar: :any_skip_relocation, big_sur:       "13e4c8224135ee78014962f4cfa8752d5ce0da5db136b64dfb3b683745324da9"
    sha256 cellar: :any_skip_relocation, catalina:      "13e4c8224135ee78014962f4cfa8752d5ce0da5db136b64dfb3b683745324da9"
    sha256 cellar: :any_skip_relocation, mojave:        "13e4c8224135ee78014962f4cfa8752d5ce0da5db136b64dfb3b683745324da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1e1d349b6067949f9a444b150802c9f340ea2ef08f433ff696e5db2c70212c"
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
