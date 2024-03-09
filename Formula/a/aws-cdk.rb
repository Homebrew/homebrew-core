require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.132.0.tgz"
  sha256 "da8fb7862f2b94c84d61c08e07fb65ce28fb7182e2f8897e679552a1f7324294"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee50ad30b517a7fed6bf44148bbbed67134dc6414ca0359c802b185433deebbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee50ad30b517a7fed6bf44148bbbed67134dc6414ca0359c802b185433deebbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee50ad30b517a7fed6bf44148bbbed67134dc6414ca0359c802b185433deebbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d954ac996e1bf67ccb0ace77ea841a67d93f5822b2f55691622a59da352b8934"
    sha256 cellar: :any_skip_relocation, ventura:        "d954ac996e1bf67ccb0ace77ea841a67d93f5822b2f55691622a59da352b8934"
    sha256 cellar: :any_skip_relocation, monterey:       "d954ac996e1bf67ccb0ace77ea841a67d93f5822b2f55691622a59da352b8934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa7c0e7baa7ea9eefddb7aeafbd027e6284e3f073e581b30b45b4d5b8f0a3a06"
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
