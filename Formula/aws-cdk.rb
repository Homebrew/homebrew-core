require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.26.0.tgz"
  sha256 "07ba83d91f7612ea387054de13f2cb80abe2a4269cffc0b23440c8962628d880"

  bottle do
    cellar :any_skip_relocation
    sha256 "78bdbc8a205aa649eea954e62cf0a3eaaf0d436814b2973a4cb832da3dbef367" => :catalina
    sha256 "3ce8ca64c1cca835493953315db2a53da5f9275a56207e7fef7db31a64d4fef4" => :mojave
    sha256 "d33227f93f13096a23b14e827b0ef6737c8c17657c301beeaf4a24e00f3d622f" => :high_sierra
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
