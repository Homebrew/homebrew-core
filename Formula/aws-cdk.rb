require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.66.0.tgz"
  sha256 "bb408ffa439521ddf683d954cba3d62e2aa6005c601d2167490476364de52f57"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "baff02601c9c90ab8ebcd1ace3d47711b2cfe503405e4da56018475cf12963a7" => :catalina
    sha256 "3c672f3c77b2096845b6656cf7762a4148daff0613569c9ffbf3ed9f92d43510" => :mojave
    sha256 "4fc327d93085e3707c685144be3ec2e88e6dcd903709eb295eeb9cf1d1af40db" => :high_sierra
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
