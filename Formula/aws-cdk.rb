require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.67.0.tgz"
  sha256 "0a1254af0de2de5ce7cdaaf78a35a30421ca8427c0320acd39e90254f9f5dbb7"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "28808b4e821100d861db765bd750a69215c627f06101c327c3c7dba2b1e6adfe" => :catalina
    sha256 "0aaa3678b2d575a836c1e04fcc9d17e74ebf8d25c3529d5ab408113134254406" => :mojave
    sha256 "af491c736bd0e49cf2fa7219fd7a96d111e400f06c2c132e5a84f14f73c226bb" => :high_sierra
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
