class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1029.3.tgz"
  sha256 "79c6120c2cddb8e27b3c18d5de38039189ce828bb8cb1cf4ef2f219666448aa3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07686eb99559018e1c9060fb108e6276731c0d794b370d7fe87324af4273fd15"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
