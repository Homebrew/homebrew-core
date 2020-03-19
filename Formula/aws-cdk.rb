require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.30.0.tgz"
  sha256 "d533bb56d409301f4c9807238d7a8d31263f18ac423359c1bd1bdd713c8d9c44"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce37c90070d64643a96d7b3c0bd87cc49561c4ff516d389ec9e0f781a08fc343" => :catalina
    sha256 "9be2d94f40a8280347afdf0955617faeef70bfd2e96ed8c8fb696dac41477b2f" => :mojave
    sha256 "27a144b383f89edd19779f8664ec17f03603570c93486b98e6e901e5f419f8e9" => :high_sierra
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
