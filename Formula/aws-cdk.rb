require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.10.1.tgz"
  sha256 "d348cc9650744de205aef72348009c7c87ad70d84fbb15516cb531a62e10e743"

  bottle do
    cellar :any_skip_relocation
    sha256 "7aaa76baf8710353b662cc1f97ce87db382042a8fbd45f5656aa4cec85cc58b1" => :mojave
    sha256 "c06d36882868e0bd4aff63ad4d11324faf83622d72036808d0cee36fb55538b6" => :high_sierra
    sha256 "e3ae17bb6905b933ec783ab802e5c22350dacbeab0afec116a9f6011680960ec" => :sierra
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
