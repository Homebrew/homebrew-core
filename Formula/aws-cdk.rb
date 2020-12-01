require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.76.0.tgz"
  sha256 "18dbba1aae1b0098d4d48c1f5486b0722c754b5de8c9dd7fc2a6b55b0e771a32"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d48a29db1264bf3940a5abaa1cd166934e7fe9fe5c00bebb80b5100c830b7d33" => :big_sur
    sha256 "56a30572ad435ecf3ccdd80184f5f93b0e30ae1a0bf02d3ac6a53253310b2acc" => :catalina
    sha256 "41bf02875b3c716ebcd6948f66de5aaedca745fca4cda597fd06fdf35e9da55c" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
