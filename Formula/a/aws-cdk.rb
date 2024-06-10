require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.145.0.tgz"
  sha256 "a82d4dbcb383dff3b375a07e72b23b3fd976e93bf291e6e144fba7f3ecb3e400"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "061bed86486ac0bd3680a64f1f710ee8b49f7804d024bdc8eaf5d9af4992ba6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "061bed86486ac0bd3680a64f1f710ee8b49f7804d024bdc8eaf5d9af4992ba6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "061bed86486ac0bd3680a64f1f710ee8b49f7804d024bdc8eaf5d9af4992ba6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "061bed86486ac0bd3680a64f1f710ee8b49f7804d024bdc8eaf5d9af4992ba6c"
    sha256 cellar: :any_skip_relocation, ventura:        "061bed86486ac0bd3680a64f1f710ee8b49f7804d024bdc8eaf5d9af4992ba6c"
    sha256 cellar: :any_skip_relocation, monterey:       "061bed86486ac0bd3680a64f1f710ee8b49f7804d024bdc8eaf5d9af4992ba6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e66b3faf8a8af0883e0be617731fd13ee358a852250b635e844c8c0941aef86"
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
