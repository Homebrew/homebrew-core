class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1126.0.tgz"
  sha256 "c17509bd82303893c4bc5a582e2d49e3b5a1f5cee656eb7c641bcbe61ed4bfc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9e520d36700a7412fce81f67fa2feed255d4b37c49b1807b173bb4eb75606b6"
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
