require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.41.0.tgz"
  sha256 "8d11776822423c38262e01371c8a2afecd843db2372a229f3e2416017a437c96"

  bottle do
    cellar :any_skip_relocation
    sha256 "70074f31d2168415876119158e8b1aaaa1e152d4107118f059be6010211e2244" => :catalina
    sha256 "4a85b47cb8c7bd7e94763449f1377e37c3b936212435c2facae1520583ad8be5" => :mojave
    sha256 "dead199a8adf16433fb2dbbda4b2366d0106385b7145591f0f104af3df8c62cd" => :high_sierra
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
