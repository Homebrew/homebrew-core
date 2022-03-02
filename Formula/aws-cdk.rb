require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.15.0.tgz"
  sha256 "06d3eaa6803304cdcaf31e49c2a3d2afdab22ccb087743e7fed4460e2ac26a16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "928136e0a788003ac566251be3cf1f3eadf595a070145b28ffae2a95bb7b33b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "928136e0a788003ac566251be3cf1f3eadf595a070145b28ffae2a95bb7b33b7"
    sha256 cellar: :any_skip_relocation, monterey:       "928d929b11ff055cb3ec98f18903097c62c7b58f9d914ad56adeb798ad9de582"
    sha256 cellar: :any_skip_relocation, big_sur:        "928d929b11ff055cb3ec98f18903097c62c7b58f9d914ad56adeb798ad9de582"
    sha256 cellar: :any_skip_relocation, catalina:       "928d929b11ff055cb3ec98f18903097c62c7b58f9d914ad56adeb798ad9de582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349d4ac7c1c5a110dc518b41153638fcb57fccc97941677502bd0a7735b28f48"
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
