require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.17.1.tgz"
  sha256 "1d2c9cced52c66c3b3434b6337d71235bd8cd9b939d385375d6d46d8cdeea1ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "17ae419e26549541ec29d8358518317dcf8105033b90292394d4114733b9dcdd" => :catalina
    sha256 "42320b3ada3e72f4259c8153d5894a198128574ac3ecfabdb73cb788124fd67f" => :mojave
    sha256 "14817e6b0677a108c54b2d902d9a2d61af9bbb664784043c0cafce09b00a71a9" => :high_sierra
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
