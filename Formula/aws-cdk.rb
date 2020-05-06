require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.37.0.tgz"
  sha256 "a0051b664ca7ab0cc821ee4138036a1027a89bae3d2acabb844ec18c9d61882e"

  bottle do
    cellar :any_skip_relocation
    sha256 "fde834ed33131ac6aa042a4e7be703a79dff651c78b219df07b2257a1431f2a1" => :catalina
    sha256 "11517c552ce8e6ca5b5eb1fe5c1ca0681ff9bbd418e2eee530646e16e6bad28a" => :mojave
    sha256 "7b8af53bac2ee975b6e86e984c40c15b6769728a7104f9ba295c93c9bfff1177" => :high_sierra
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
