require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.17.0.tgz"
  sha256 "8ec3c1ec9b785d519f84011db8a20711df723ba8292f7e0fe892371b2b39f25c"

  bottle do
    cellar :any_skip_relocation
    sha256 "233d9762358a9d26565f31c32733b15520eb63c7917cf811c66c2928507c300c" => :catalina
    sha256 "e560348e586fb301c6b9fb04c36d7d411eac5fcccbf6b4681dd3ef1c072c94ac" => :mojave
    sha256 "bbc5138c45cf8208513c0f3a5a1535121371e7158d460c60b56d6c0daf508b0e" => :high_sierra
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
