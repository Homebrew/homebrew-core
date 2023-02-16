require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.65.0.tgz"
  sha256 "8ba465393105266540d05bcec50ce14be8524094ad230ad9d6ea8dad547ee25c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f543cea99697404c5105ae4822da404c8de218a38e0f8cc3049dcc9f38f69a2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a032ead0b2e060b8cbf3bbdb58d3ea827750f9a58c7589622116bef7cc47b2ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "096dfd3519c4b3ab0b1134b68836850fcbc41b2d14a7883a34ba9aacc6687de9"
    sha256 cellar: :any_skip_relocation, ventura:        "770aa89b054fc125a64de92d48de86177ae551faa8bb248577e216e8431bfad7"
    sha256 cellar: :any_skip_relocation, monterey:       "94667e4ff8e37371ac1d94a9eb4f43fa1767b60779dfcbf611937fc785ecff4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d7967360e7a69f250bcdad6baa361abc9c5eb5bb036616529b4e40e1eefe688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4c0c6204be67c94dd8e325af7b97bf3d053c3a67917c261e31418151b94ca8"
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
