require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.121.0.tgz"
  sha256 "59da982690f1093f685e21e9ac4f06f8d922fcab49086a5b2c043e8f530491d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07b8044e66d5388f0a837da5f86a7d7d4da4ef3f9e16ebfb3d240ada9c7ad147"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4d381054189cff96dd7fa160ee339a3112c1f26326f429176a519e2f6683275"
    sha256 cellar: :any_skip_relocation, catalina:      "c4d381054189cff96dd7fa160ee339a3112c1f26326f429176a519e2f6683275"
    sha256 cellar: :any_skip_relocation, mojave:        "c4d381054189cff96dd7fa160ee339a3112c1f26326f429176a519e2f6683275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b8044e66d5388f0a837da5f86a7d7d4da4ef3f9e16ebfb3d240ada9c7ad147"
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
