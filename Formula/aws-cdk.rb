require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.75.0.tgz"
  sha256 "cfa3f75d6cfe5bad5c629b99137b257cf0f0f88847d4e1d274169544d406e85f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2b93004aba9748ea2451a51983224851721634c29482c1084cd6f34e0b132e94" => :big_sur
    sha256 "823f90ffca8d281e2577a365d6dd1e44851efce7ac434e214ab340b6a466e828" => :catalina
    sha256 "5e1d7d636aa79641d5338f03c331c56622419ba531393f1f4c674e00d98f46ec" => :mojave
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
