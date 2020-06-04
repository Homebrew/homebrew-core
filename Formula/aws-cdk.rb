require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.43.0.tgz"
  sha256 "a9c221533dea2eec00f583ea18bf36b23d211b518a6cc142e5bc7a3e01314a01"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbdb7135f58eb8b35820df9f0c885d405df4429bfc323e1dd9ceb9039d28617f" => :catalina
    sha256 "6cc43f3b53ca4d4a00fb304289e626ebaa985c599813deb3f365a72eac679c6b" => :mojave
    sha256 "959522818375d1646c62943f309f5aaa6a8ad12bf04e1bd7e01838c13b3ae596" => :high_sierra
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
