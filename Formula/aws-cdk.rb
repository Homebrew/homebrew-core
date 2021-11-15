require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.132.0.tgz"
  sha256 "79cc04b473a3ed2e441b180ecff46e73b30a2baa6c6f6243d0e110773b01953a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b4ef1fd7a9e762b9511225302731ace2cd551e0ae344411a91e01870e152325"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b4ef1fd7a9e762b9511225302731ace2cd551e0ae344411a91e01870e152325"
    sha256 cellar: :any_skip_relocation, monterey:       "6a014f49d0edee09359fc50fb51b14cc56ab452245479608dedb06126691e1a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a014f49d0edee09359fc50fb51b14cc56ab452245479608dedb06126691e1a1"
    sha256 cellar: :any_skip_relocation, catalina:       "6a014f49d0edee09359fc50fb51b14cc56ab452245479608dedb06126691e1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ae01bfb30d8b22fbddaf9328c20d20962f1c81f5ddd6d3ac3d15d8bf7a9cd2c"
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
