require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.128.0.tgz"
  sha256 "39e17016adf4b6c52fd5c24bca20cd3461a754a708f4135f5d134dee36851a6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48246810bc0aecd36b996b00d76a8e5666c06f4cc8f88710a970ab0947d203b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48246810bc0aecd36b996b00d76a8e5666c06f4cc8f88710a970ab0947d203b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48246810bc0aecd36b996b00d76a8e5666c06f4cc8f88710a970ab0947d203b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "224724a570a87ddd8f6dc55c7d0f01d3fb8d66be0861b5e95d027f7e582220d3"
    sha256 cellar: :any_skip_relocation, ventura:        "224724a570a87ddd8f6dc55c7d0f01d3fb8d66be0861b5e95d027f7e582220d3"
    sha256 cellar: :any_skip_relocation, monterey:       "224724a570a87ddd8f6dc55c7d0f01d3fb8d66be0861b5e95d027f7e582220d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c79de2187034f5096515a00c346d509fc30e808ab0e4f6c113d4ddedd76aad6f"
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
