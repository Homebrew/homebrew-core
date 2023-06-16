require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.84.0.tgz"
  sha256 "1c41a0cefe8682c79d2d061e816a61e27c0e7527892d576f865c3e5a4cbc2708"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df9f65fdc0354e053ea1b8b1b975567e43591ccbb1d935c07c6a4d0c6631b632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df9f65fdc0354e053ea1b8b1b975567e43591ccbb1d935c07c6a4d0c6631b632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df9f65fdc0354e053ea1b8b1b975567e43591ccbb1d935c07c6a4d0c6631b632"
    sha256 cellar: :any_skip_relocation, ventura:        "5bb613897fe4245413ab5cede763564f8a7d0bcc12f57059f013720deae6bc75"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb613897fe4245413ab5cede763564f8a7d0bcc12f57059f013720deae6bc75"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bb613897fe4245413ab5cede763564f8a7d0bcc12f57059f013720deae6bc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86a5bebebec429bfddf3dcffdda8085499046d93cd6ed6ebd79e3a66d6f1a4d5"
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
