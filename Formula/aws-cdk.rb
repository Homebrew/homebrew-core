require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.71.0.tgz"
  sha256 "155ba1aec0eeae3b14942c7698613303568c39a9ac4148eee563ea3bdb5de7b8"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fc3c809d0ad0d834ab88c201d6ccbcf5af486dabe199130387300fbb02612fcc" => :catalina
    sha256 "1dfb798d70936ebb6d192fd65e88637d9aa39455adc851d7f72841fc2a5e0140" => :mojave
    sha256 "9974e0416ddf6096b3f37266302ed90edef642f9992c151b3e1c9fe1cd04af9d" => :high_sierra
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
