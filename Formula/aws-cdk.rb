require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.6.0.tgz"
  sha256 "3bba9428418f367023a6c1d2b19977dddc9f1e9f4f1cf4f2e94cdd3753d73a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1297095f82e06dbed3a5434259b71f6e3e1136b05566fb94ee32ca77f625073a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1297095f82e06dbed3a5434259b71f6e3e1136b05566fb94ee32ca77f625073a"
    sha256 cellar: :any_skip_relocation, monterey:       "7b46f17d5ed323e0ed9d21f68022d933fd6c50f38920b492e8968f56bacf765b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b46f17d5ed323e0ed9d21f68022d933fd6c50f38920b492e8968f56bacf765b"
    sha256 cellar: :any_skip_relocation, catalina:       "7b46f17d5ed323e0ed9d21f68022d933fd6c50f38920b492e8968f56bacf765b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b008226517f61b820a248f0913b133d8bfd2eefe813c38e404fdbdd709503a86"
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
