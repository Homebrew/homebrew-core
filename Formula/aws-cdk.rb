require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.32.0.tgz"
  sha256 "e72f3ee4eb6cbc98c15ffdef9438174e60c7415886b78b3c6cf04b186aa76fdc"

  bottle do
    cellar :any_skip_relocation
    sha256 "98b8f0dd001f9c7e1174a7562195fd285a633fd5d6e4a64861545b6d66d54076" => :catalina
    sha256 "9b65c5f17f6c7fef63493f8ef4518ab387843f2d8a856893e3600d796d1ba7f0" => :mojave
    sha256 "805812bceceb1d7a3fbf99ae526cdabad66298fafa119db32fc9b0540c138b51" => :high_sierra
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
