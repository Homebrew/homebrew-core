class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1106.1.tgz"
  sha256 "939c256fd73f1427e785fad3863401ed8ad68f89068a2941eb2329050edeb852"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "706d596e30ee58fbafbe5eed886efb7a12ce66c846a019500b84fe064cb1948b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
