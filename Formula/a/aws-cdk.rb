require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.130.0.tgz"
  sha256 "79e503f16aac6959a80325d982fcc211aaa8c1db6b721575cc8846be4c8d4cbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0caf7f8a9481ff247f47459ca4f4f9af7c321cdc2c7fcb4aef1203642576ce62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0caf7f8a9481ff247f47459ca4f4f9af7c321cdc2c7fcb4aef1203642576ce62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0caf7f8a9481ff247f47459ca4f4f9af7c321cdc2c7fcb4aef1203642576ce62"
    sha256 cellar: :any_skip_relocation, sonoma:         "822cfd19b5827d9bd0b249986afedfbcd24ef089ba2c9d026ec15d2e1cf633dd"
    sha256 cellar: :any_skip_relocation, ventura:        "822cfd19b5827d9bd0b249986afedfbcd24ef089ba2c9d026ec15d2e1cf633dd"
    sha256 cellar: :any_skip_relocation, monterey:       "822cfd19b5827d9bd0b249986afedfbcd24ef089ba2c9d026ec15d2e1cf633dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d22adedcd79e7629acf6214347cbcb071a84f8c4832cc9452c09cae8b1e900"
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
