require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.13.0.tgz"
  sha256 "70a609f099fd382c327d93fcbd9d6e2ee95b17f3dde9012af703ca9e9cfc3897"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f1deba5ca87b2af806828259da6fcf22fbc9b251c34efc2482015ae211a03c5" => :catalina
    sha256 "c6fd0202ee30e003cbd84c1d463ee6189842e3e55a1941034ccf73d4aa824cc9" => :mojave
    sha256 "627d460d28bb0972cac2105fb68712d4bcd7858d9675bba17d6274b5b214bca7" => :high_sierra
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
