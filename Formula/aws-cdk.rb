require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.93.0.tgz"
  sha256 "dcd0a18edd1ee73976a1fead966ecc118916d123be74b5dd2b4f4d7e15b68375"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0bf4301df5ea3dfa3f14f8c84ae7b72240119a82bc50edaeddb00307eb471bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b89207ac83450b55b13507bcebecbef8357c02c586bdc8633d5648800482748"
    sha256 cellar: :any_skip_relocation, catalina:      "4222d871d7644502b561cd78fd0e527f3e0535e4027adf87fbc6403c11646539"
    sha256 cellar: :any_skip_relocation, mojave:        "2ea2d66d0355f6b5f40e45c2365893a5ba8688153c154b0621b17ee720411688"
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
