require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.19.0.tgz"
  sha256 "3f0888a86901baefda9bb952a1f09a4ba29c3b2c512fc5860f6ecc8e90724557"

  bottle do
    cellar :any_skip_relocation
    sha256 "79bf2f3d795a6856338085cf1c614d3d528801a71842899b71ec1922572d0ca1" => :catalina
    sha256 "c4981547e2d647982326ef29dad1cb8c422e9504030621de9df253889d9d881d" => :mojave
    sha256 "97e82ce41bc2dcdafe2d8b658dd63cbc3fe834dcbf6e0415f165683877b80401" => :high_sierra
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
