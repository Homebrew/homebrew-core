require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.69.0.tgz"
  sha256 "cb534b73e2960665fe252fabf6b10295e70d7cd99c1285797fc2e9a834cd7cb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2053f5e8ea9c2c8cc0bb0139ebac67aaa84e639f51ef7a1cffce10926e388f5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2053f5e8ea9c2c8cc0bb0139ebac67aaa84e639f51ef7a1cffce10926e388f5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2053f5e8ea9c2c8cc0bb0139ebac67aaa84e639f51ef7a1cffce10926e388f5c"
    sha256 cellar: :any_skip_relocation, ventura:        "1670ad9a56ba54ae7da2546b6c7d94034d9750c1a726a93741ce3a84513e809d"
    sha256 cellar: :any_skip_relocation, monterey:       "1670ad9a56ba54ae7da2546b6c7d94034d9750c1a726a93741ce3a84513e809d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1670ad9a56ba54ae7da2546b6c7d94034d9750c1a726a93741ce3a84513e809d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1adb0729333ec335c43df2276e661f8f203d979b7fb6c7314c6fe9c37733468e"
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
