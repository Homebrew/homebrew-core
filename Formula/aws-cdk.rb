require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.42.0.tgz"
  sha256 "a413c8b36c85b988c253053b354fc7c7655d84087bb3a17dfc71e30748393d9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba0fd971c2157309ba1e201f663660494f3dcc345a35ac1a0ac5557a746f1b37" => :catalina
    sha256 "f6be484557e15074dfe1c6277927e03d0483340f07cdaac7e25d2f9409db3256" => :mojave
    sha256 "8bd05913796bba461f8cde0e7f87543dac3663be607707855d08b06683507682" => :high_sierra
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
