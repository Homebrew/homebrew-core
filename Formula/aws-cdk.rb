require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.83.0.tgz"
  sha256 "e1bb3ff4346147baa8ab392d1be27593552c9ce22e53b971c41301b4d46ce045"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ef09469cd0b7a66487df29252e98e6bef8247340c3f6eb87d20d70c1ef2f96f8" => :big_sur
    sha256 "08a48202bda31322f34d88ab00da78a84a0aa237072c708d4c31892ccca8fe3f" => :arm64_big_sur
    sha256 "9e5b34e5ad0c52c469b3c68370aff707a82161d7eab50967e13687f80ddec736" => :catalina
    sha256 "355ed4d5fcbe85b04bb5c3fbeaa1f5f3791556afa0241c10345f10795bc627db" => :mojave
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
