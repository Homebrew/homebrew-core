require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.29.0.tgz"
  sha256 "cd505656a97bb28de042a12e9145c02fe631ea2d3509b6009a51c39a6ed33c11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7f3d2cc8b733b8031faaf3b5782e187bf70fac62dea135d7cb00219f031f13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee7f3d2cc8b733b8031faaf3b5782e187bf70fac62dea135d7cb00219f031f13"
    sha256 cellar: :any_skip_relocation, monterey:       "c731a18cf762e922b897013dbb60e6326ee4d7aefe5b168401f48b249b68d3db"
    sha256 cellar: :any_skip_relocation, big_sur:        "c731a18cf762e922b897013dbb60e6326ee4d7aefe5b168401f48b249b68d3db"
    sha256 cellar: :any_skip_relocation, catalina:       "c731a18cf762e922b897013dbb60e6326ee4d7aefe5b168401f48b249b68d3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e630bc730ef3a49fa6d91515b6bfa87720c2547f03fd58be6b468a6e9d8083"
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
