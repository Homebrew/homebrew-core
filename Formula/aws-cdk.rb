require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.87.1.tgz"
  sha256 "f4c10698b431b295c18ac046c365f5675dd99b606dd6d236022a6557d168ef9f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5012388bb550fbf8b243c4c5653b5f0548337be6565e55195c6a454e3d10367a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f15abff5ce6f538b3898b959655835a9a2aaec816dd5e1bcbbdfb5c8b8c9ef4"
    sha256 cellar: :any_skip_relocation, catalina:      "6af5af974898ad2b37b0d332f778674780a78d5eae5eba51c9915fe77fcf143e"
    sha256 cellar: :any_skip_relocation, mojave:        "899925378b32c1cf89d83d75912e797523ddfa5312708a9e28e006479b6dc88d"
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
