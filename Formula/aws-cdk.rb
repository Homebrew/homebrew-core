require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.28.0.tgz"
  sha256 "3efb14aaef8b83eac220d8320ff5167650e45a23259dd2ba142a31d9fa16fea0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5988928d66ac18722d7ad238698a834f1ea494d63aab803746b94289e6dd7c1" => :catalina
    sha256 "dc9d71455f74e86036371a1305bb4b6a7b2fa670d25b323d5923df068fb59368" => :mojave
    sha256 "ffe9b102023f4bb3bbff03decde9753542b5e0c7039a41d6e5ccec7c80202e41" => :high_sierra
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
