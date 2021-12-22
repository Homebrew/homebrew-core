require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.3.0.tgz"
  sha256 "07e446d5723e19a8558b83b15341f57fb4d350bf31677e89404674ed7fb5b0a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4a94d363b74b08aa6141d639e57fa70f181dab6244687df60a92b8ec05667e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4a94d363b74b08aa6141d639e57fa70f181dab6244687df60a92b8ec05667e3"
    sha256 cellar: :any_skip_relocation, monterey:       "b84a5dc6e103e6516d01a569e1602ac983a50103d044b84e3212d70478758940"
    sha256 cellar: :any_skip_relocation, big_sur:        "b84a5dc6e103e6516d01a569e1602ac983a50103d044b84e3212d70478758940"
    sha256 cellar: :any_skip_relocation, catalina:       "b84a5dc6e103e6516d01a569e1602ac983a50103d044b84e3212d70478758940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33eb9d2eaf5ea893519dd7545154f0f3dcb1ab09302eaac2e0a26f1bbd892e7b"
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
