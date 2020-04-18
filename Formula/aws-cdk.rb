require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.33.0.tgz"
  sha256 "9eb1c7f0b51611efa9b3e006edf37b954b2d9006282a9384a0591e180c0bf3dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "b63d7d0677fc73f74b083f4e2da4f7262b8d304bfec82e71872d90c6423ec9d3" => :catalina
    sha256 "30dd0cdf588e802df0c95b51b1297bc307c8ba5fc07c470c999f3d6c2ef04dc2" => :mojave
    sha256 "14e3f46a9a3a458df656c6c094eb37ee77baa53fd679302b7d1a6b88000ba266" => :high_sierra
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
