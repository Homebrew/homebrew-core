require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.30.0.tgz"
  sha256 "d533bb56d409301f4c9807238d7a8d31263f18ac423359c1bd1bdd713c8d9c44"

  bottle do
    cellar :any_skip_relocation
    sha256 "8757a84c83e9526e5bb068c2646985f259a67b2fdd20cec469e368a90e28b313" => :catalina
    sha256 "f2f1b9722473e5de2fd4ffc5459da6ac6c5aea740414fc7edfd1d5128cd5545a" => :mojave
    sha256 "d5267eda25f8e4059888d0e50c10dba9eb74763060c764b07b6da0b4015802d0" => :high_sierra
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
