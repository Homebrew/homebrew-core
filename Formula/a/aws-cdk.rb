require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.115.0.tgz"
  sha256 "19b9c344ad80e936731809ac3998542c171ea7b5f47cd74f81e137552097dab5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c31faf6663ec2652c7ffbc025369bdf2365d79b8f815da2da95e8377ef3f6621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c31faf6663ec2652c7ffbc025369bdf2365d79b8f815da2da95e8377ef3f6621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31faf6663ec2652c7ffbc025369bdf2365d79b8f815da2da95e8377ef3f6621"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9d6572cbfc87ed914379ecc107751c44e7bfc04dcb8b695bae03a80711efd13"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d6572cbfc87ed914379ecc107751c44e7bfc04dcb8b695bae03a80711efd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e642ede7e4ff2d2c2628d400360a59ac3a013b6979224525fc3fd8114ed5d42e"
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
