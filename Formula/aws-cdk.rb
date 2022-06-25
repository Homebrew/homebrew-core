require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.29.1.tgz"
  sha256 "ebd5656e4e85e0cac781d16584715a3145f597f27021876e602a605d74626559"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ddbd2e88a38b6c34063ecb00ae8456caa4e3c80d169f124036b79e1266733f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73ddbd2e88a38b6c34063ecb00ae8456caa4e3c80d169f124036b79e1266733f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6efe9c708496de195faec60ab8dc26c1c8c196399527a0f77198da80dcdca16"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6efe9c708496de195faec60ab8dc26c1c8c196399527a0f77198da80dcdca16"
    sha256 cellar: :any_skip_relocation, catalina:       "f6efe9c708496de195faec60ab8dc26c1c8c196399527a0f77198da80dcdca16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0395c53507480608db309d3f877aa7ce095e27deabde6e00da16a555ba5d91dd"
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
