require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.76.0.tgz"
  sha256 "f9ad5464c48b76baf493f53bcc871316414e32649caf3ec4b69c8f7b73f724a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e241c55eb0c7c67048c0ccbb817acca09f9c44ddb430031bff6e56abe62d36c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e241c55eb0c7c67048c0ccbb817acca09f9c44ddb430031bff6e56abe62d36c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e241c55eb0c7c67048c0ccbb817acca09f9c44ddb430031bff6e56abe62d36c"
    sha256 cellar: :any_skip_relocation, ventura:        "a151978cfd0b4b13892371460acd591e19ea36423d6645a1f3d8c4c3febb202a"
    sha256 cellar: :any_skip_relocation, monterey:       "a151978cfd0b4b13892371460acd591e19ea36423d6645a1f3d8c4c3febb202a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a151978cfd0b4b13892371460acd591e19ea36423d6645a1f3d8c4c3febb202a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15f4f545dbfaed06c6a712fb75319d8b8a9947de540a32f3fe981f00498f4d4"
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
