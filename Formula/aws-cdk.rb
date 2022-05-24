require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.25.0.tgz"
  sha256 "c3dd51596cd8d0700a2acc53d94d319e9d2d7dbcc722256434a7785009c32bf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2002d683d6a74dadf3659b32cc4375744b0c9a00bb5da3c3613d9bead2729171"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2002d683d6a74dadf3659b32cc4375744b0c9a00bb5da3c3613d9bead2729171"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c7418b748846b3ddadb44634c07e61ccd0efbae20d11d1c310398f8df1b332"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5c7418b748846b3ddadb44634c07e61ccd0efbae20d11d1c310398f8df1b332"
    sha256 cellar: :any_skip_relocation, catalina:       "c5c7418b748846b3ddadb44634c07e61ccd0efbae20d11d1c310398f8df1b332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d103223b9973e95eb662e0de71a7e554fbb39f990ab607765972b2abcc34291"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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
