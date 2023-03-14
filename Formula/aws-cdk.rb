require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.69.0.tgz"
  sha256 "cb534b73e2960665fe252fabf6b10295e70d7cd99c1285797fc2e9a834cd7cb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfabee2979a13e6d9013eff1ee9a3a7f95f7fb50c119e04368563e3c5e411203"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfabee2979a13e6d9013eff1ee9a3a7f95f7fb50c119e04368563e3c5e411203"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfabee2979a13e6d9013eff1ee9a3a7f95f7fb50c119e04368563e3c5e411203"
    sha256 cellar: :any_skip_relocation, ventura:        "b6b742ef991f1a7237bd0bd29c22efc048f7d0569f6009d84b5c9ad2ab523a29"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b742ef991f1a7237bd0bd29c22efc048f7d0569f6009d84b5c9ad2ab523a29"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6b742ef991f1a7237bd0bd29c22efc048f7d0569f6009d84b5c9ad2ab523a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df201ca416018075d350e879a810bae2a7db2d241e3972025830af3d2cf9ac67"
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
