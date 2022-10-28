require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.48.0.tgz"
  sha256 "891d9a2001898182286e2675717f3def5cf9693c6041ab06f6b00e4a46b4c092"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0841815ffa7ec216daccc478f1204cf46917864a9f3e77c38ca60da65ddb60d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0841815ffa7ec216daccc478f1204cf46917864a9f3e77c38ca60da65ddb60d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0841815ffa7ec216daccc478f1204cf46917864a9f3e77c38ca60da65ddb60d"
    sha256 cellar: :any_skip_relocation, monterey:       "ed5bcb323166ac0f21bbeb3df6cc9010922a9d37f2f07493b55dd4814c6244d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed5bcb323166ac0f21bbeb3df6cc9010922a9d37f2f07493b55dd4814c6244d3"
    sha256 cellar: :any_skip_relocation, catalina:       "ed5bcb323166ac0f21bbeb3df6cc9010922a9d37f2f07493b55dd4814c6244d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e7cefccd9d9c7aa76d72019b06f6ec24b24572c2c0e3e258c38fb02c868c97"
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
