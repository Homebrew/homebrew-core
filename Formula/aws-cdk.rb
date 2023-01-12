require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.60.0.tgz"
  sha256 "d20d30dd84aae24fd0fad62a8d3803cb09e62d8e36f68fe0643e1c3c2fe6ca66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "841a4ab0057456f82d2d295127859505276966e69ff8a9b2d3ab916989fdc555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "841a4ab0057456f82d2d295127859505276966e69ff8a9b2d3ab916989fdc555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "841a4ab0057456f82d2d295127859505276966e69ff8a9b2d3ab916989fdc555"
    sha256 cellar: :any_skip_relocation, ventura:        "4547f39e41ca9eda4b9935f81a02db259c459229fd6455921af301bd088d0f22"
    sha256 cellar: :any_skip_relocation, monterey:       "4547f39e41ca9eda4b9935f81a02db259c459229fd6455921af301bd088d0f22"
    sha256 cellar: :any_skip_relocation, big_sur:        "4547f39e41ca9eda4b9935f81a02db259c459229fd6455921af301bd088d0f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59aa6e0cc6a1cad66cb3ed425429ae71f03feb835e376cf417077a53be48bdc2"
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
