require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.60.0.tgz"
  sha256 "0078458a22b6303b6d3ec4459542583ce032fce9442a00e8ccee200ee5713959"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c071b9f8a0014fa853b0e4bb206461fa0cbed0a94dac325680785dc59888a340" => :catalina
    sha256 "cece3dd08cb757657c399545e3d1522a0eb58944fe85c3874bf5efb3ca43866b" => :mojave
    sha256 "b8e879de96ce20910a01311fff17e737797f92efa1016292b388ddb087db221c" => :high_sierra
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
