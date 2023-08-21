require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.92.0.tgz"
  sha256 "97dd7f09e77595ffd74d3cf331492c1f00c2fe7dab082ff8f34eed65056991a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e841227793b87e42299cd5d1b882a5f8f939f6967bb7fa104d54fa9de1ac82a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e841227793b87e42299cd5d1b882a5f8f939f6967bb7fa104d54fa9de1ac82a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e841227793b87e42299cd5d1b882a5f8f939f6967bb7fa104d54fa9de1ac82a"
    sha256 cellar: :any_skip_relocation, ventura:        "62263b3cd3d12281457fe0cc8139a4c18b337877a86d79d395a4812948f05381"
    sha256 cellar: :any_skip_relocation, monterey:       "62263b3cd3d12281457fe0cc8139a4c18b337877a86d79d395a4812948f05381"
    sha256 cellar: :any_skip_relocation, big_sur:        "62263b3cd3d12281457fe0cc8139a4c18b337877a86d79d395a4812948f05381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "267875ad8f138b47be9381f38268b6d183e9a4317b62e20001d40fcc983809a0"
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
