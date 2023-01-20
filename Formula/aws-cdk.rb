require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.61.0.tgz"
  sha256 "f7a24bdf636843504b650717eba07edeb55ac60848e56748c3b0a28a3a114442"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed55db9823171b75a0cb87b73d3ffa649c76658abad9083cc7c7179633be2c1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed55db9823171b75a0cb87b73d3ffa649c76658abad9083cc7c7179633be2c1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed55db9823171b75a0cb87b73d3ffa649c76658abad9083cc7c7179633be2c1b"
    sha256 cellar: :any_skip_relocation, ventura:        "17368aa93c757e8a94748aadf854ab180bc683e0c6c43a4d0c6d31bba854a8de"
    sha256 cellar: :any_skip_relocation, monterey:       "17368aa93c757e8a94748aadf854ab180bc683e0c6c43a4d0c6d31bba854a8de"
    sha256 cellar: :any_skip_relocation, big_sur:        "17368aa93c757e8a94748aadf854ab180bc683e0c6c43a4d0c6d31bba854a8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e7ac982f4f17628de211d5aae9aa10525c619b488d4f392924f5f4266ce9ba9"
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
