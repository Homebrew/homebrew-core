require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.128.0.tgz"
  sha256 "76fd9e1c55974a9e42275f8e6a34096e5d6054aa8711a9d88402c88fe9d0c865"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2c1c7673b6b801abd64c339d6c4a8104a6a050061ac948ff2979d590524bb45"
    sha256 cellar: :any_skip_relocation, big_sur:       "99db7b2e7d1ea38b39e4b87286fbb83fd07d5352a65ac4cf67036c76576dd790"
    sha256 cellar: :any_skip_relocation, catalina:      "99db7b2e7d1ea38b39e4b87286fbb83fd07d5352a65ac4cf67036c76576dd790"
    sha256 cellar: :any_skip_relocation, mojave:        "99db7b2e7d1ea38b39e4b87286fbb83fd07d5352a65ac4cf67036c76576dd790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c1c7673b6b801abd64c339d6c4a8104a6a050061ac948ff2979d590524bb45"
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
