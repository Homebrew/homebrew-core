require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.10.0.tgz"
  sha256 "8c1484aae7e45523a73836ec84740258dc81c9b69fb00f457518c33879c8c410"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebe0841120e758446c5384c6e51d482ffb2d453e473f263568d30f59c39a34e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe0841120e758446c5384c6e51d482ffb2d453e473f263568d30f59c39a34e2"
    sha256 cellar: :any_skip_relocation, monterey:       "d47f431c05e746f503efd8f4adf4b12ad8b4c0cc6a8782fd2cf0601cbb9a0516"
    sha256 cellar: :any_skip_relocation, big_sur:        "d47f431c05e746f503efd8f4adf4b12ad8b4c0cc6a8782fd2cf0601cbb9a0516"
    sha256 cellar: :any_skip_relocation, catalina:       "d47f431c05e746f503efd8f4adf4b12ad8b4c0cc6a8782fd2cf0601cbb9a0516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c7dc5d42a3614b18bc4cb01d73bd752275b28fe17c1d418e908ab3d2814624"
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
