require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.122.0.tgz"
  sha256 "36c00296a3e9f3b0a54e349b8c34a2f0fe3e3aae3330c9f6bd783c72c5980b44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77655a68323f42c322da05efbd2b96fe8bf57923a83f73501425fb2928c7026a"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f915bfcbcaa121211d2e4ce377d0e64a842f5b02e3bd39edb171100dc81f1af"
    sha256 cellar: :any_skip_relocation, catalina:      "2f915bfcbcaa121211d2e4ce377d0e64a842f5b02e3bd39edb171100dc81f1af"
    sha256 cellar: :any_skip_relocation, mojave:        "2f915bfcbcaa121211d2e4ce377d0e64a842f5b02e3bd39edb171100dc81f1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77655a68323f42c322da05efbd2b96fe8bf57923a83f73501425fb2928c7026a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
