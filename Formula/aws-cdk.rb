require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.101.0.tgz"
  sha256 "775609194c81b46830e839178874d518993b85436704d92c56cae865c605dd20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ce2dbf4b4405b504e7d2a47cc999b3e7a2fee87cd3411287890527e8a0ffbe5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9baf1d8b38ab2fc604d4ffb7d8dd11c86d6c71344f419ad8c4565248651b877"
    sha256 cellar: :any_skip_relocation, catalina:      "d9baf1d8b38ab2fc604d4ffb7d8dd11c86d6c71344f419ad8c4565248651b877"
    sha256 cellar: :any_skip_relocation, mojave:        "d9baf1d8b38ab2fc604d4ffb7d8dd11c86d6c71344f419ad8c4565248651b877"
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
