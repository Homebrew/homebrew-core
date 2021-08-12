require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.117.0.tgz"
  sha256 "c8f165a689dd198501a8fa5992a6f283366cfcbc69fca046ab24e1687834dd78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a135caad3c9ca5cf1da31179b987ad552dae0cf4708cad5aaae9d454fcd8cdb"
    sha256 cellar: :any_skip_relocation, big_sur:       "06e55418cde5fc86018feabe2b877710ab1f563890ab093b322b4d9c4e1f5412"
    sha256 cellar: :any_skip_relocation, catalina:      "06e55418cde5fc86018feabe2b877710ab1f563890ab093b322b4d9c4e1f5412"
    sha256 cellar: :any_skip_relocation, mojave:        "06e55418cde5fc86018feabe2b877710ab1f563890ab093b322b4d9c4e1f5412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a135caad3c9ca5cf1da31179b987ad552dae0cf4708cad5aaae9d454fcd8cdb"
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
