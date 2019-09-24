require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.9.0.tgz"
  sha256 "543d9820b88fae29232aa2c4dc72286a43adc0195edf8aec562d2ef1c41bfd8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0568e563f000a16b78d7d6c665c3e25d10cdd86442551ea486985f91177efba9" => :mojave
    sha256 "9d69a052320a14f897936257f5bf379057515789a4c6339deb469aee30fb5fde" => :high_sierra
    sha256 "aad1cd993aa1c27ed773fa7f573512bb1828de63813c822d5a6c66b91ecda033" => :sierra
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
