require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.49.0.tgz"
  sha256 "48605c91ba69824db631bb0beb28f766ef33a3ebf6e5f10b0bf6f79c44994dbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39cc63822e43c9751529b07f170236220ca925b5a9745676be8becfe8372522e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39cc63822e43c9751529b07f170236220ca925b5a9745676be8becfe8372522e"
    sha256 cellar: :any_skip_relocation, monterey:       "132bfa8d32ecedd1f540445f0f3007c9bed3c35b10ea61aa68abb28384781b0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "132bfa8d32ecedd1f540445f0f3007c9bed3c35b10ea61aa68abb28384781b0f"
    sha256 cellar: :any_skip_relocation, catalina:       "132bfa8d32ecedd1f540445f0f3007c9bed3c35b10ea61aa68abb28384781b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d8d2245c9fce20f248f0b9c3b82bc068b3c4be836f6821393cda3606c9c6c2"
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
