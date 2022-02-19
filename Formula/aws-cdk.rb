require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.13.0.tgz"
  sha256 "7375b5d86f11e18b6a8f77ae9a6cf5037bb557623a4f24b39589045f209975e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e87f1bbaa30b53a3e71a5e98de0567a9aeaacd68dd44d5e5975cbe86b89308"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52e87f1bbaa30b53a3e71a5e98de0567a9aeaacd68dd44d5e5975cbe86b89308"
    sha256 cellar: :any_skip_relocation, monterey:       "975a734312a8d48a85dc8611a1f52e2e2c7c04428f026ba60bf00f0e81ea2593"
    sha256 cellar: :any_skip_relocation, big_sur:        "975a734312a8d48a85dc8611a1f52e2e2c7c04428f026ba60bf00f0e81ea2593"
    sha256 cellar: :any_skip_relocation, catalina:       "975a734312a8d48a85dc8611a1f52e2e2c7c04428f026ba60bf00f0e81ea2593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ea1be080327c8c0392dc51516df70f2350effe9d1f36d846e50bd1d10d4aaf"
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
