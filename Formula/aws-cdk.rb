require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.34.1.tgz"
  sha256 "1d08b9201f877b50ae0dcd04015d17649d88132d27e26a4e565a4c179768fc26"

  bottle do
    cellar :any_skip_relocation
    sha256 "36016daffa2166048d43b7906c15e9b7685f084c6ac49adc449ec5939807eae4" => :catalina
    sha256 "03d5b22d72dabd1ce04e140384efc29db7e4591dc2f22e81f424427034f10601" => :mojave
    sha256 "06b990ac459b269dc5ebd84773af1fef087c8d8c7811f948897d0cc17a6cfd21" => :high_sierra
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
