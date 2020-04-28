require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.36.0.tgz"
  sha256 "907b7e2e35831d900da2dd07391963ab322cee2d83e73eb284ef91b9cf9bba62"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbc4bda3821e9e8edda7240bdc50928b5903ebf7dee61abc18dc99c6ae5be500" => :catalina
    sha256 "1cf459bf0c02aa924d84b39e64546f65f50f7035c87c8d38377c4dc2baeec73b" => :mojave
    sha256 "59a4d9775afbe0a480dc2520914a3b91e3ef2c26fed0966b6e98a043f8abb213" => :high_sierra
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
