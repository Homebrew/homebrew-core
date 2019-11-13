require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.16.2.tgz"
  sha256 "29f60209dad40fa7f32c867c03e1856f0dc83ef8ce1c679f78f9f326f76c04a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c3937b1c95c7fd9d6bd61833a97b12fc68645605485388064f239a06fd1a0d6" => :catalina
    sha256 "dac1a331e17bb4beb2e9e08d72ab41411e0ca9420276fd8cf4bcc8a7b3db8e0f" => :mojave
    sha256 "dbf71e996940e16c8f20f1f6a45dda4e269a42d0b9d348c6f376a60789784467" => :high_sierra
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
