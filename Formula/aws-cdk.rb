require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.91.0.tgz"
  sha256 "54365ba4bd26b8e4641c1b31e8945bda985333ca780593a7bc51ffa445e579e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2d2b029f41397736fef342c9862037577fe7a5e9b4cf4851d8cba1c1a36b72d"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c48a90d9b655ba3cd890f69bd244574ce8972ad60d0cbba60dcc984b35e4b29"
    sha256 cellar: :any_skip_relocation, catalina:      "e4a066dbb1e017b6a72ba788965be5fbb5e9c5d625a7cb47005d01d118664717"
    sha256 cellar: :any_skip_relocation, mojave:        "34a610caed1e5ae33f592647f3d27011d84151fa51fa029a3ff058415816659d"
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
