require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.17.1.tgz"
  sha256 "1d2c9cced52c66c3b3434b6337d71235bd8cd9b939d385375d6d46d8cdeea1ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "30d20f94a4bfe1f62ad155dcaa55721417259039401b87258e3ac1df927c29f5" => :catalina
    sha256 "c21b06ceddc5ef085194e8abe4a527eac217369923e8c653a9b66a9a944307e1" => :mojave
    sha256 "4de3da96966539e7fb137e52eeeb11cf2f57d9ebf49c3834b30381dd770eb8e5" => :high_sierra
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
