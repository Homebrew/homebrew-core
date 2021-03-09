require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.92.0.tgz"
  sha256 "9ead5e81a18d6d3dae96c29d3ecdde42e64756c4413b49f8fbf0cc7a8f3fcd52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a522af84d1cb33068479194417a64ea9bb77e11e80f44838517e602bd3403535"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e66f4a98a6a178812aac079a32107d593c32a5dbd249bd5e2ff5d5d7cd8d6b9"
    sha256 cellar: :any_skip_relocation, catalina:      "d9ba3c863f51d3985eca1589812d336dc786c79dae411262e05ac333495749a6"
    sha256 cellar: :any_skip_relocation, mojave:        "2edefc35b9d643302fae9faee48f29a97a1766ca201c190b57016c5152b5dfae"
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
