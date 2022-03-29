require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.18.0.tgz"
  sha256 "8d9a2ea4a11cc175b66439e4dec96e696399173b35424923b21d2e98104c03dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bcb969036e4a80aaed2488eb88fb17125ab1e5a8e7c031213e99a884d76a286"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bcb969036e4a80aaed2488eb88fb17125ab1e5a8e7c031213e99a884d76a286"
    sha256 cellar: :any_skip_relocation, monterey:       "ba659f3e2dc50ad6750e44f82f86eb6827d36f996888ee4c83bfb39a3af455f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba659f3e2dc50ad6750e44f82f86eb6827d36f996888ee4c83bfb39a3af455f3"
    sha256 cellar: :any_skip_relocation, catalina:       "ba659f3e2dc50ad6750e44f82f86eb6827d36f996888ee4c83bfb39a3af455f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4eb63852a79c544138dda5610f35431d4da5691202ba2876ed40699d8b4da9"
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
