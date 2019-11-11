require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.16.0.tgz"
  sha256 "4094e6ff489436a79930798ed490f9f1747ddb6bcb8ba2f005f291060cea4462"

  bottle do
    cellar :any_skip_relocation
    sha256 "31ab53bfd56eb57cbaee058c472b1f80add1ca1c4c482900ceeaf31bdd5e1c6f" => :catalina
    sha256 "5de65709a2c5fc67c27e00f7b33a03e3e1d2996859d151be37cce699d00c862c" => :mojave
    sha256 "311a6c5b8e325f78f478be1ed68dcb518809272f532d93a7f14d330ff3160fc2" => :high_sierra
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
