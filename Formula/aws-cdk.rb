require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.74.0.tgz"
  sha256 "0b1a7a46a50ffcf760eb289695320a9b3c081ea474934f08619acdb613147fba"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dc56bac76f7c1039c32f65519edc4cd6b030db933e7c5186a6aeaf828b4b1524" => :catalina
    sha256 "ae017105118a4b0ebc5e78dc1e445726961c4f16a4ad6522dd1050af4ea81a2e" => :mojave
    sha256 "8a5cd362ce8a0ab623945798c968c8e3325e4ddb316e52a2da30bc4a7f850f69" => :high_sierra
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
