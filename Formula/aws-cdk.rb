require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.28.1.tgz"
  sha256 "6cc10c927cbc10be72970a86f31b2319f9ff211b8fa874397ee11bb2707226bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c08e92123a6d6d693ba227c2c865d311fb8330331fdc1c58c25448729bdebaa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c08e92123a6d6d693ba227c2c865d311fb8330331fdc1c58c25448729bdebaa3"
    sha256 cellar: :any_skip_relocation, monterey:       "0672cb746a50f0afa309cea3ab4be6c200d9b82941cc8e0808c26b3f7227d0c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0672cb746a50f0afa309cea3ab4be6c200d9b82941cc8e0808c26b3f7227d0c5"
    sha256 cellar: :any_skip_relocation, catalina:       "0672cb746a50f0afa309cea3ab4be6c200d9b82941cc8e0808c26b3f7227d0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10dd7b85a396cfe4d2d76b9c19ccc19e36cf55d9e7315c8cd8da72588284d1d5"
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
