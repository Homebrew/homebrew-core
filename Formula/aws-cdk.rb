require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.44.0.tgz"
  sha256 "cee34b741a3aee4b4b2a01073c52cdc7d23404db00b05511265d40033eb672e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "82e9982f8bad939c9c27e862150085879c99713d60ef4875d76c420fbfbebbc1" => :catalina
    sha256 "131f3fe88c4f0872832dcb68fff56ef15ffaae71f0972c6a4a69613f574ddb4c" => :mojave
    sha256 "7b34199805540a3ffd0d0be8b76f7674eab860c2c8ebee349dafce8417ef11b9" => :high_sierra
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
