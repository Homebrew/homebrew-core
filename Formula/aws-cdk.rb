require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.90.1.tgz"
  sha256 "8fcde9340841742157a82206d36d6bdcebd825234de543f89021c3dd554c7c0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0818c518330367b279c1ce94800503dfe4e247743ef66d466911cdacd4342792"
    sha256 cellar: :any_skip_relocation, big_sur:       "86b9a38598939dc5d3aea37c2362ccac557ce6839221fb472d83dee74628ff1a"
    sha256 cellar: :any_skip_relocation, catalina:      "f69e34339bf72645580a56713b0c4d3306d272001a3cc92f0646801ccf89800d"
    sha256 cellar: :any_skip_relocation, mojave:        "af370b1abfa3200b400d971825e5cf4b7408eedc6d201805260715fb5968a11b"
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
