require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.63.0.tgz"
  sha256 "f4f7cdb419abf4fc210bb3aaaed6abdb546678db4680e6f4bb703af32134222d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7a83b3248a2d9494e736a00d74893e0a58aed670826a0783bf53d369e07c078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a83b3248a2d9494e736a00d74893e0a58aed670826a0783bf53d369e07c078"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7a83b3248a2d9494e736a00d74893e0a58aed670826a0783bf53d369e07c078"
    sha256 cellar: :any_skip_relocation, ventura:        "c222a568c96c1c44e9c8f749feab469fa4af1c7b8c181dce31f43c6af6e8f1e8"
    sha256 cellar: :any_skip_relocation, monterey:       "c222a568c96c1c44e9c8f749feab469fa4af1c7b8c181dce31f43c6af6e8f1e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c222a568c96c1c44e9c8f749feab469fa4af1c7b8c181dce31f43c6af6e8f1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627cbb8ed5a02533cd299713a0e080dac1483f1cf8350e4136b0ddbc36cfe693"
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
