require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.46.0.tgz"
  sha256 "25b9c8860c61a9e46e3d5359cfd88f437fd45c3f9934a2f19e53de1bc28075c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f4b94bf9d389f2fb05ffe03f654af2e388a264541a2c9be770443065570fbe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f4b94bf9d389f2fb05ffe03f654af2e388a264541a2c9be770443065570fbe8"
    sha256 cellar: :any_skip_relocation, monterey:       "00b5be209daa788072213144f115ae2b4b42d090d8b8a55c894f2bf4c64d0fa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "00b5be209daa788072213144f115ae2b4b42d090d8b8a55c894f2bf4c64d0fa9"
    sha256 cellar: :any_skip_relocation, catalina:       "00b5be209daa788072213144f115ae2b4b42d090d8b8a55c894f2bf4c64d0fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1ed9c627be0536b3186adc08f1b108de140029a9bf0d3abd7b800a12f392e6"
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
