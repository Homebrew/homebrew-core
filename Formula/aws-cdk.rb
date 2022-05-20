require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.24.1.tgz"
  sha256 "70a9ee6435d5d70313dcfbeed28243f57325876c46e43cdfb79c1d8211786733"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed9c8df2239590eabf6ab710b9c1616e83abc9653899b31c2fe8da5b4ae1623b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed9c8df2239590eabf6ab710b9c1616e83abc9653899b31c2fe8da5b4ae1623b"
    sha256 cellar: :any_skip_relocation, monterey:       "28587386383bfead431752f84c5780ae65223d57c3a4a4009c371653dfe94ace"
    sha256 cellar: :any_skip_relocation, big_sur:        "28587386383bfead431752f84c5780ae65223d57c3a4a4009c371653dfe94ace"
    sha256 cellar: :any_skip_relocation, catalina:       "28587386383bfead431752f84c5780ae65223d57c3a4a4009c371653dfe94ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "361ac5158656ae261fa61813be222e66233b0e70ebd7015e3196458388414ede"
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
