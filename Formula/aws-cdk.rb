require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.20.0.tgz"
  sha256 "793b49f0a0f138ae2ed0d40254ded92ebe651014c9c7c29583bb9c8d55a2eb5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4706190b601789cced76e8af635fb2c90f650c4599456cc2e6a68879ef9fb3d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4706190b601789cced76e8af635fb2c90f650c4599456cc2e6a68879ef9fb3d4"
    sha256 cellar: :any_skip_relocation, monterey:       "11d9da05aa80a52bee02ca7ceb3981642b4b07d8e2600aafff95abb686e891d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "11d9da05aa80a52bee02ca7ceb3981642b4b07d8e2600aafff95abb686e891d9"
    sha256 cellar: :any_skip_relocation, catalina:       "11d9da05aa80a52bee02ca7ceb3981642b4b07d8e2600aafff95abb686e891d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ca1c9a1d7ac65666f2ee5e37b9e49c0bb23fb1f589cce3c5d5f2e771ae7217"
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
