require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.118.0.tgz"
  sha256 "e8888638bbf33510f4b4c05e4cffa52a1f9a58e9bad639194ac729dedd25f753"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e4e1eb2b3a418f0f4429b01d4906ae11e8965c9096df8d377ffc59109d98188"
    sha256 cellar: :any_skip_relocation, big_sur:       "516ed888828fe9d12755aca944a44efc20d17f0f0b08328883b0e1cad357d150"
    sha256 cellar: :any_skip_relocation, catalina:      "516ed888828fe9d12755aca944a44efc20d17f0f0b08328883b0e1cad357d150"
    sha256 cellar: :any_skip_relocation, mojave:        "516ed888828fe9d12755aca944a44efc20d17f0f0b08328883b0e1cad357d150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e4e1eb2b3a418f0f4429b01d4906ae11e8965c9096df8d377ffc59109d98188"
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
