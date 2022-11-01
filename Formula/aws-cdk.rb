require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.49.1.tgz"
  sha256 "33b44f6b1714f835b5907c965f8038aedd058804bd60513804dcb4548ec50369"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c592a606f50a7a563503d182b210da49add30820660ccaf3612a283e4245a26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c592a606f50a7a563503d182b210da49add30820660ccaf3612a283e4245a26"
    sha256 cellar: :any_skip_relocation, monterey:       "54de75de68049d09583363fbad07d01ef6af72bdb5fd1f9cd7e6ba8ea797edef"
    sha256 cellar: :any_skip_relocation, big_sur:        "54de75de68049d09583363fbad07d01ef6af72bdb5fd1f9cd7e6ba8ea797edef"
    sha256 cellar: :any_skip_relocation, catalina:       "54de75de68049d09583363fbad07d01ef6af72bdb5fd1f9cd7e6ba8ea797edef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90d7ed8e58b09b00d23d4eeba20827c99819451800e28470342921160ac7930c"
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
