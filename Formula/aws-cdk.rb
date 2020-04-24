require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.35.0.tgz"
  sha256 "ac57a1d077fc3179923b71311aafd51c7608455922c946b558a171308e699196"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f37118c6826a9b12a6a16117d865dc86b1906ee23f01443594d30e8cdbc1d0d" => :catalina
    sha256 "4130e600c76da36b2387dc0203af60bdc50dc22fda4cdfd819432b61f8eb81e4" => :mojave
    sha256 "d388c6532a9462d32be1d51010b2d2bf3fb37c70e933aa0a8ae7ed4be57d52a4" => :high_sierra
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
