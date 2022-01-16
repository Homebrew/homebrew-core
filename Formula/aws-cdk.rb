require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.8.0.tgz"
  sha256 "5c7dcb5cf58612e9b1c1696c55bf031f7ec0bdfd476231d91ae9410532edf098"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ab53811725dbab30482282a0776907192f59b51fd1a3559588f0e0547956d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01ab53811725dbab30482282a0776907192f59b51fd1a3559588f0e0547956d1"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7c525784aa8d5f1b88d5b81d22edc99976f43fe8771001630469c8f65975d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc7c525784aa8d5f1b88d5b81d22edc99976f43fe8771001630469c8f65975d6"
    sha256 cellar: :any_skip_relocation, catalina:       "bc7c525784aa8d5f1b88d5b81d22edc99976f43fe8771001630469c8f65975d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b77b9569a8b1ec4327a053878c2531d99c4795746e5e43b838ef601bb81c7a36"
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
