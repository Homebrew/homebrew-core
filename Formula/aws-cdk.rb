require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.28.0.tgz"
  sha256 "79a794a32e66ab0023210620f75480f9a565bae9b39f544d396ea65815aa0f79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5fa0b411d75a9710a0d3da2bfab8f774910100c6909384631390fd38d2b61c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5fa0b411d75a9710a0d3da2bfab8f774910100c6909384631390fd38d2b61c8"
    sha256 cellar: :any_skip_relocation, monterey:       "9e2702ec4e1a1bbb11de3812542986b4e3795df2dd0da418ddda28f1d06e6ba5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e2702ec4e1a1bbb11de3812542986b4e3795df2dd0da418ddda28f1d06e6ba5"
    sha256 cellar: :any_skip_relocation, catalina:       "9e2702ec4e1a1bbb11de3812542986b4e3795df2dd0da418ddda28f1d06e6ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d550eee23ad693f01f99e43094f92e0df107d19c7bdc84399f39e92fae7d7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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
