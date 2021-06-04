require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.107.0.tgz"
  sha256 "28b07aa6bbc61f3032cb199c9c1eb3db4bb69e38ff3ae740fe2af2e88ff21ad5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54dc379957e332338ef925df17d09babb851a2f942263d8e1e8afd5f17d77397"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac4b7cbbbf1a448b532413c3d66ebeb5348b2b54dc6b81ed23b080c7564244fb"
    sha256 cellar: :any_skip_relocation, catalina:      "ac4b7cbbbf1a448b532413c3d66ebeb5348b2b54dc6b81ed23b080c7564244fb"
    sha256 cellar: :any_skip_relocation, mojave:        "ac4b7cbbbf1a448b532413c3d66ebeb5348b2b54dc6b81ed23b080c7564244fb"
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
