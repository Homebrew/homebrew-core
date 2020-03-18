require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.29.0.tgz"
  sha256 "a8ab298315a86f942f270c3be02a91e287cc50f627d6dcff020ceefc796aa378"

  bottle do
    cellar :any_skip_relocation
    sha256 "58d102b57b06acaf1fe20a1075c5da9634384c005aca9ccceddbd3174dc8c3a5" => :catalina
    sha256 "e72efdff3103489431aeb8bf65b82df313dfd0939e9d65969f392c48df51dc0c" => :mojave
    sha256 "b015293a74a8b3697ee1b92c367211716408b81c33c728acb31169ec7849def0" => :high_sierra
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
