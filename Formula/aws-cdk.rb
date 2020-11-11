require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.73.0.tgz"
  sha256 "2bf4c03e3b2912b6657f632caeb402509876eb00b3383bc8cd4237e5925f7d24"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3a1178041284735e12c0e965e406373f2d91000b1d259cc3bc21a349045ef896" => :catalina
    sha256 "8c32e8ad9ffa4b67279daeeb057c617389ba8bfafc6f04b30ab5f3d5174fc756" => :mojave
    sha256 "2337fcea001c9109ce4cf7494b6260bb944d7ba8bf1947cd41e21e65029a25aa" => :high_sierra
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
