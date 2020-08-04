require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.56.0.tgz"
  sha256 "658855e5749723bc35d07afb78f9308df9f4793987be2558c7374bb92cdb1825"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "99c00cf96d31dd239d9fd3cc251f53539542693ab18c28375289f0d827e264cc" => :catalina
    sha256 "ffa4c0b61e70b7b8081dbe01ee6c9fcf775a370b9b1907ece564a9abb59ff672" => :mojave
    sha256 "0b966ae819605f383b5999000800028166d7bd7c48583d537dbf7b8b8952d520" => :high_sierra
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
