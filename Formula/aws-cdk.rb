require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.12.0.tgz"
  sha256 "dd04d51e6951b30a6d44e22b00f638361c3033f6d8c8fde4905ce46e909d2ecb"

  bottle do
    cellar :any_skip_relocation
    sha256 "209310128f8f561791c399c0f588beeb0fdc95d20e13582a040a646b2048c8f3" => :catalina
    sha256 "ec41cc4fb0f6102b729d433ff1e89e4a1daffa2f259b71aa50348cfd182e78a9" => :mojave
    sha256 "398a2c97fa3d9002bca73d782499faf4e6c4b78c3d284504689832416a923f39" => :high_sierra
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
