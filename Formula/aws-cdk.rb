require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.50.0.tgz"
  sha256 "8fd8e8c30b45e2e2f00b0e855f0381d8320bcfa347d7800bce81fa215d97ae55"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d771ba5a219d5f00b6e319babb52e8c06493bc36c2d58de70c23dd9e2bc02e4d" => :catalina
    sha256 "3024f6a9e3aa17c6438b2317b3d099323b815c8a82149867faa5926e377dca01" => :mojave
    sha256 "465d44c0ec0a7e71821ee9cebbbc5544a95e202a8488422931b8f452fbb1d460" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
