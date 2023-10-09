require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.100.0.tgz"
  sha256 "b727059e1854e9f1fff32b23230afac6c2b8afbeb50474b4c193ec297421f921"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b1162c04a6b77db045a5ff33bf069c1f6ab8bc5e8c0ed3eb7a5fed886d98014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b1162c04a6b77db045a5ff33bf069c1f6ab8bc5e8c0ed3eb7a5fed886d98014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b1162c04a6b77db045a5ff33bf069c1f6ab8bc5e8c0ed3eb7a5fed886d98014"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0a4ac8ebc08e18a964220ad4f2d607637fbd87c9e11d1fb2ace1861120f876f"
    sha256 cellar: :any_skip_relocation, ventura:        "f0a4ac8ebc08e18a964220ad4f2d607637fbd87c9e11d1fb2ace1861120f876f"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a4ac8ebc08e18a964220ad4f2d607637fbd87c9e11d1fb2ace1861120f876f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd4e0a8592a49ba34813e16161b739eb3b7669ee90c2680b253e9669bef6d7d"
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
