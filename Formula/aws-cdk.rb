require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.117.0.tgz"
  sha256 "c8f165a689dd198501a8fa5992a6f283366cfcbc69fca046ab24e1687834dd78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e515f4d4be58824ecd70e944cc431d82b25142579c4ec0cfa42aaabb60f79a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1478250cc204de5fabde74be9e994a095a3641fb849dac653adbbe674a7bf127"
    sha256 cellar: :any_skip_relocation, catalina:      "1478250cc204de5fabde74be9e994a095a3641fb849dac653adbbe674a7bf127"
    sha256 cellar: :any_skip_relocation, mojave:        "1478250cc204de5fabde74be9e994a095a3641fb849dac653adbbe674a7bf127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e515f4d4be58824ecd70e944cc431d82b25142579c4ec0cfa42aaabb60f79a1"
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
