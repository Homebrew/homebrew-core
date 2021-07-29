require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.116.0.tgz"
  sha256 "76bdbf9def718829f25ddcc4243b989585c2fbfd83d6449c4b16c88bfd047bf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2875b8a483d808bd52a6db13c143ff5f4267ed96a9f1be07c5dbe0524a17ca40"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9cbe6116d7dffbb3ca9856cac6fa1d20c1c12b96d5c4480732dfec796341dae"
    sha256 cellar: :any_skip_relocation, catalina:      "c9cbe6116d7dffbb3ca9856cac6fa1d20c1c12b96d5c4480732dfec796341dae"
    sha256 cellar: :any_skip_relocation, mojave:        "c9cbe6116d7dffbb3ca9856cac6fa1d20c1c12b96d5c4480732dfec796341dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2875b8a483d808bd52a6db13c143ff5f4267ed96a9f1be07c5dbe0524a17ca40"
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
