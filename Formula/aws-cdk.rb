require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.83.1.tgz"
  sha256 "34df0f5ebc69e402583baccf5db1544714277978a78094f5d226eeb2630ab3f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e2453b913afc228bbdd6061bfc3ebd6fe501e4c9056ba21dcf5a0b250cae747"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2453b913afc228bbdd6061bfc3ebd6fe501e4c9056ba21dcf5a0b250cae747"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2453b913afc228bbdd6061bfc3ebd6fe501e4c9056ba21dcf5a0b250cae747"
    sha256 cellar: :any_skip_relocation, ventura:        "cbc9897e43fd4515cd2259c694e7dac8a06023875483e6b0d6107a251149cac1"
    sha256 cellar: :any_skip_relocation, monterey:       "cbc9897e43fd4515cd2259c694e7dac8a06023875483e6b0d6107a251149cac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbc9897e43fd4515cd2259c694e7dac8a06023875483e6b0d6107a251149cac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1aece52793e9f6d3dc1b5d8e169ecfc1afc6dba2d66b7cb15b962836bf8884b"
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
