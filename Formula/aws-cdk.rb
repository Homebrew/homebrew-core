require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.21.1.tgz"
  sha256 "97ca367e809df5d113ed1be1b22ad3bd79849c1e09725377357c22f182dd1f0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2ddbda5e79af6b6fd2d10b253381631518b6d9b9e3b01249f7809fb8886090d" => :catalina
    sha256 "70350256c55942a9b4584d6d4d556789b712b35ba3fe1d3f17fdb12a3db77c65" => :mojave
    sha256 "c890f8997c90dd4b4b1b547506840e08bba76f7706f72ffed8d14077decb6485" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
