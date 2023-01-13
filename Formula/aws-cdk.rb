require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.60.0.tgz"
  sha256 "d20d30dd84aae24fd0fad62a8d3803cb09e62d8e36f68fe0643e1c3c2fe6ca66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da81f67b43ba5d17d77acb042ae65f96a2ace624b86a8b9ad590046f2401180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da81f67b43ba5d17d77acb042ae65f96a2ace624b86a8b9ad590046f2401180"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5da81f67b43ba5d17d77acb042ae65f96a2ace624b86a8b9ad590046f2401180"
    sha256 cellar: :any_skip_relocation, ventura:        "1c0394b4e3e82a26d56db347219612915192d0d1c9515e2651c7bd8f09953601"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0394b4e3e82a26d56db347219612915192d0d1c9515e2651c7bd8f09953601"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c0394b4e3e82a26d56db347219612915192d0d1c9515e2651c7bd8f09953601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57efc3f5cd88c9226b753758d5357f71223d5cb9f10bad2356697d8d58014fef"
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
