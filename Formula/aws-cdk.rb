require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.74.0.tgz"
  sha256 "e3759cb02130b589d7b6508a7af38c357a29fd2a278ccfb043a8c8b892e256e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42a43b5897eb71489a17917fa6651dd2c01442cae295897baef7ea3b0f628ae3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a43b5897eb71489a17917fa6651dd2c01442cae295897baef7ea3b0f628ae3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42a43b5897eb71489a17917fa6651dd2c01442cae295897baef7ea3b0f628ae3"
    sha256 cellar: :any_skip_relocation, ventura:        "d3adb6b141a5fa047616ab6773af0674636f0a8b4f46db062ff1440e02be7819"
    sha256 cellar: :any_skip_relocation, monterey:       "d3adb6b141a5fa047616ab6773af0674636f0a8b4f46db062ff1440e02be7819"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3adb6b141a5fa047616ab6773af0674636f0a8b4f46db062ff1440e02be7819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4840234e3708052f9c2aae5f5eb13c583381da6d578fafc982f36dd27c1fb10d"
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
