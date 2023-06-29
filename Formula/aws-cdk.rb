require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.85.0.tgz"
  sha256 "b68c06d833b6008fed88cfcd414143f5861f7cc537a7122ae4efe63e92fbb502"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "225cf76d7aaa24d951ed0d8549f051d66b675e484e9c4a9b7a881211dd5250ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "225cf76d7aaa24d951ed0d8549f051d66b675e484e9c4a9b7a881211dd5250ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "225cf76d7aaa24d951ed0d8549f051d66b675e484e9c4a9b7a881211dd5250ef"
    sha256 cellar: :any_skip_relocation, ventura:        "5e84d6190357862ef997f7af523c7ee052d5bb80c4d0daf030574439373dbe43"
    sha256 cellar: :any_skip_relocation, monterey:       "5e84d6190357862ef997f7af523c7ee052d5bb80c4d0daf030574439373dbe43"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e84d6190357862ef997f7af523c7ee052d5bb80c4d0daf030574439373dbe43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf4c1cb62884e0e7590bce0f4e36a928268c8889f4d84553e55908490a6bf86a"
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
