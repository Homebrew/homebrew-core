require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.62.1.tgz"
  sha256 "e95ec9c0919a1c081b65611ea1ce99eb0ecd829c9cabf2716e49fe1e406fd459"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7533cb34b0229cc7fb162621de6987fa724944d0ee0fde042c87a4b252e031b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7533cb34b0229cc7fb162621de6987fa724944d0ee0fde042c87a4b252e031b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7533cb34b0229cc7fb162621de6987fa724944d0ee0fde042c87a4b252e031b"
    sha256 cellar: :any_skip_relocation, ventura:        "7a3808b965cf2f431e568c10869dc07e03c8b854acf1b264deeeff9ba29c62e1"
    sha256 cellar: :any_skip_relocation, monterey:       "7a3808b965cf2f431e568c10869dc07e03c8b854acf1b264deeeff9ba29c62e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a3808b965cf2f431e568c10869dc07e03c8b854acf1b264deeeff9ba29c62e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811afb5ed4bacfc957d933b1c3c14794bf00d34a60b0ab765b48c3c2319d0b3c"
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
