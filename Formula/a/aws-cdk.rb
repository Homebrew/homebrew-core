require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.146.0.tgz"
  sha256 "7ff5775efc35b3f0a305f97d4069c1ecc9686af32125d425a22d39090c9a982b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9e0999d37d45a3d46f05be1c05d39568987582aa5eb4b58ef68179087cb295e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9e0999d37d45a3d46f05be1c05d39568987582aa5eb4b58ef68179087cb295e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9e0999d37d45a3d46f05be1c05d39568987582aa5eb4b58ef68179087cb295e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9e0999d37d45a3d46f05be1c05d39568987582aa5eb4b58ef68179087cb295e"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e0999d37d45a3d46f05be1c05d39568987582aa5eb4b58ef68179087cb295e"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e0999d37d45a3d46f05be1c05d39568987582aa5eb4b58ef68179087cb295e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07676a75a7dc9b583ad145c15d5b841831165b047c2b9e32d33389e79f48ff9"
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
