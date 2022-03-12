require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.16.0.tgz"
  sha256 "084e3406ff86dd84867b33fec9dcb825262f67289c01971ad7fa7fd0e3bb109d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a247de47a1c0140cb2e963b0405ded57d501b2a50959c64b9d7dd11a7a23bec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a247de47a1c0140cb2e963b0405ded57d501b2a50959c64b9d7dd11a7a23bec6"
    sha256 cellar: :any_skip_relocation, monterey:       "ad83714e7eaabf423b4586c04093061203ada33bdc4dd78bf03ea2458de5373e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad83714e7eaabf423b4586c04093061203ada33bdc4dd78bf03ea2458de5373e"
    sha256 cellar: :any_skip_relocation, catalina:       "ad83714e7eaabf423b4586c04093061203ada33bdc4dd78bf03ea2458de5373e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1f9e46d7f9d87f14fcdd07929538059af57d6a426ec22232e555039e13c2dc5"
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
