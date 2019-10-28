require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.15.0.tgz"
  sha256 "c32b020bbce21a696d7aa7b23342ea6d94ff9af4cf1593f17bd5a812f7402242"

  bottle do
    cellar :any_skip_relocation
    sha256 "a387c67794bcb88b8b67db03ccd0b4d8d5256729b09baf91d1604fd78b561c0e" => :catalina
    sha256 "26cbac8ceb63e353c517917bad7d62ba41b21d32a73bf483fb35b868d764b160" => :mojave
    sha256 "38e2b4fb435055e757f2c88532e4c69dd45e768a7de1f30ba4dd92153ce8f2d3" => :high_sierra
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
