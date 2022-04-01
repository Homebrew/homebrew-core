require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.19.0.tgz"
  sha256 "c0d34fb05854cd6b9b7da3dd07228804879cc64b7791ac46fdaf8ff57fcf43d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fac1f6650c7213bf66e1688ba87400a0ed479c34f262e331d2999f144d840ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fac1f6650c7213bf66e1688ba87400a0ed479c34f262e331d2999f144d840ae"
    sha256 cellar: :any_skip_relocation, monterey:       "b4763103d5f1a5be3bbbf669cd0d3e5c6d8bfa19aca32e652f7b43326d85362a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4763103d5f1a5be3bbbf669cd0d3e5c6d8bfa19aca32e652f7b43326d85362a"
    sha256 cellar: :any_skip_relocation, catalina:       "b4763103d5f1a5be3bbbf669cd0d3e5c6d8bfa19aca32e652f7b43326d85362a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d298f9668a4c9071cf0658a6ea8e483fd06cd54ab43dce5580871685e0651e6"
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
