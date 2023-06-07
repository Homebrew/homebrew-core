require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.83.0.tgz"
  sha256 "d4bc1c32c890020cfb7486fa978ddc26c1979cbd7d7ece400d90ed4d24dcb0a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a88effb4f297dd43c24a23d9f86e85c5250897ba9e00e5b090048058faca76d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a88effb4f297dd43c24a23d9f86e85c5250897ba9e00e5b090048058faca76d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a88effb4f297dd43c24a23d9f86e85c5250897ba9e00e5b090048058faca76d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c5374476787b88823fca598fe37de958dc1902577f4518e897ff43447031ce"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c5374476787b88823fca598fe37de958dc1902577f4518e897ff43447031ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8c5374476787b88823fca598fe37de958dc1902577f4518e897ff43447031ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67edb5135c8f52ef1b2c49edc67ddf71bfb3e398a796d77865064967e653383e"
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
