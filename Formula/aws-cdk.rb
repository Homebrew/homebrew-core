require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.16.0.tgz"
  sha256 "084e3406ff86dd84867b33fec9dcb825262f67289c01971ad7fa7fd0e3bb109d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26d27a949b306d7126bd078b9ccae6058b94c1ac3f6010321dd124b3fae5f6ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26d27a949b306d7126bd078b9ccae6058b94c1ac3f6010321dd124b3fae5f6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "543047a926614e932d4bfe7823eff3864aaa766c51b3e06da6fc577b641c35c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "543047a926614e932d4bfe7823eff3864aaa766c51b3e06da6fc577b641c35c8"
    sha256 cellar: :any_skip_relocation, catalina:       "543047a926614e932d4bfe7823eff3864aaa766c51b3e06da6fc577b641c35c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e4ec04ff4c294e019baad96862251059ba7a475dbcbb041c28a7f236a37afb7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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
