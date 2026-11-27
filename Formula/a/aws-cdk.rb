class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1149.0.tgz"
  sha256 "fc11f7ea79d34024eb00cf055b40d5d2020361a094298c16c29b01920ab9ad56"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "054f6d9c151c121b143b377178d271698b00f4c598cc68cf74af2a6dc52ad089"
    sha256 cellar: :any_skip_relocation, all: "c87badabdbdc6df2ffd1b0f7546d2b32345f03ee1346615267ad160ee3943fc4"
  end

  depends_on "node"

  allow_network_access! :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
