require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.12.0.tgz"
  sha256 "d9aa29808bfac991cb2f1d3dd8696c08884412e5e50ecc8c969674364a3cb885"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "201d9e6fcbd4e841a31621d09bed52f2e17853e915597494e05da403bbf73bea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "201d9e6fcbd4e841a31621d09bed52f2e17853e915597494e05da403bbf73bea"
    sha256 cellar: :any_skip_relocation, monterey:       "454e1f8459e61d436c21d16e575f92da9f4f8a76fa04ebee71baf99e020eb41c"
    sha256 cellar: :any_skip_relocation, big_sur:        "454e1f8459e61d436c21d16e575f92da9f4f8a76fa04ebee71baf99e020eb41c"
    sha256 cellar: :any_skip_relocation, catalina:       "454e1f8459e61d436c21d16e575f92da9f4f8a76fa04ebee71baf99e020eb41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a2d2ad675866d1ec5f3d1a112adb690c2769b32a10276e883bb479b5fa43035"
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
