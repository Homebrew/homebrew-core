require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.97.0.tgz"
  sha256 "a10d3139e27e8f33e0cd3e5a03fd177fd6ca213dddc281dfb06d2c0a0c2f6b02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2de3b3e8c84fedfdc21c6615996dc0b8998d16a30c82fdf788f544e87572c15b"
    sha256 cellar: :any_skip_relocation, big_sur:       "63c9e7e35f8887732db5f9b4757425e5770a5427751d9b16dd671196ff096bcd"
    sha256 cellar: :any_skip_relocation, catalina:      "abf03f1b380c95ceabef71cded46519ed8c6f145c0e610218f80ea000ce0ac63"
    sha256 cellar: :any_skip_relocation, mojave:        "d5671a5d255e7bc21065dededba80ae924ed73134d1480717a9d7439d203e225"
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
