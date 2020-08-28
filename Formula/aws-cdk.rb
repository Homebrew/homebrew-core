require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.61.1.tgz"
  sha256 "e43c63411a99db7878a4c407f675a46e8f70a571dba94dd7b4c2972396a3a0e3"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "82381156155628b61394a4ae03da1f5b02a04b032d4510d8d9cd7ab167a28a2c" => :catalina
    sha256 "58d8f4d0849445f7ee582e164f5bc54f5aa76de567a4cffbfafaf64dde68401f" => :mojave
    sha256 "fc5e9b8bc172a10af32efde48830fe13cebd15e24409baa9cb14b0c513b9cb3d" => :high_sierra
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
