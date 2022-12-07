require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.54.0.tgz"
  sha256 "e9fdc2954543fadb88aa18d0ef0a3007f1ab33fc691111aec7bb11f78f0cf9a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1876049a6492a49cf1390268b6bcb6bfb4a5f10328cd3f07f27bed93d2112508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1876049a6492a49cf1390268b6bcb6bfb4a5f10328cd3f07f27bed93d2112508"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1876049a6492a49cf1390268b6bcb6bfb4a5f10328cd3f07f27bed93d2112508"
    sha256 cellar: :any_skip_relocation, ventura:        "055b01ae28e7ce0b03cd015a8bb19febc879df9ad8015167014ecb3b2f372011"
    sha256 cellar: :any_skip_relocation, monterey:       "055b01ae28e7ce0b03cd015a8bb19febc879df9ad8015167014ecb3b2f372011"
    sha256 cellar: :any_skip_relocation, big_sur:        "055b01ae28e7ce0b03cd015a8bb19febc879df9ad8015167014ecb3b2f372011"
    sha256 cellar: :any_skip_relocation, catalina:       "055b01ae28e7ce0b03cd015a8bb19febc879df9ad8015167014ecb3b2f372011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "261f7ae3769d5bd1c7a23ce2660afe2cb0e1d94cc2c71b9bf1c3c196ed2b6dcf"
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
