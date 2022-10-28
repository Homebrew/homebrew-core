require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.49.0.tgz"
  sha256 "48605c91ba69824db631bb0beb28f766ef33a3ebf6e5f10b0bf6f79c44994dbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc20f0e632dac34103c3fde49ee20c3396d5cfef49cd405ed03a026a34a6218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc20f0e632dac34103c3fde49ee20c3396d5cfef49cd405ed03a026a34a6218"
    sha256 cellar: :any_skip_relocation, monterey:       "4bddb4c5e9c402d0a5df5b9129a64b87d715f19ed8d213487ff3fb7207c49767"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bddb4c5e9c402d0a5df5b9129a64b87d715f19ed8d213487ff3fb7207c49767"
    sha256 cellar: :any_skip_relocation, catalina:       "4bddb4c5e9c402d0a5df5b9129a64b87d715f19ed8d213487ff3fb7207c49767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f65834af2d6a373717a7bd3a5f46c072ff094e8ffa987602cfe6da319a69564"
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
