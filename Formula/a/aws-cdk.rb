require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.137.0.tgz"
  sha256 "d59869a87a5144c34ac6e75e90665467e21e31bf74a64717c20a28fd7f907dac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "150958cf3f95fdf34c45523be4dbc7bcf6561f812bf26e92bdba211242c88fc9"
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
