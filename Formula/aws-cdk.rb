require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.86.0.tgz"
  sha256 "3825ef860613873c6a538fe913090774bae2e1b927f4df3c8d44bda58577a54c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "99453d259662e15170bc505f964aea4a326b114a755c18372f6f545d5eedb9f9" => :big_sur
    sha256 "e959252b7c85a104073036ac3bcc61b4c52f11362e8f5131af0ab8afc1d1c855" => :arm64_big_sur
    sha256 "baa38ec2dcbb479058867f6af4884ec76f14c72246151ff9d2fd4a217c47689a" => :catalina
    sha256 "f3d994b19099a9496303f1a18ed53be415e937cb2d7ae8cdaa8ae224e0114200" => :mojave
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
