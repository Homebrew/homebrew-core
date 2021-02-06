require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.88.0.tgz"
  sha256 "13b58d2939b74afca6b48c2c9cd18df41f3578664ba568f1741d0a24430c54c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db4f53ac6f43d594e001419e389e3cb7eaade2b8e55c49c0f77501cdcc55ae4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c42fe319ba690757281ad68420396425219bc796bf58ccd2830e9be2297deab"
    sha256 cellar: :any_skip_relocation, catalina:      "a92171a5f012e5dcf1273e81fb5847ae0fdb26859dbf8fec9a5308d77043f8b4"
    sha256 cellar: :any_skip_relocation, mojave:        "5ba181b093e520e08b06288996176cb83a5b9a18a39b1da5f64befd2262412d3"
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
