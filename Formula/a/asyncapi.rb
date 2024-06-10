require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.0.0.tgz"
  sha256 "d48337dc6c64a22168a776d3a2eafd7adfea280435b51dd4b3a4545930ee4423"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36fef77d65663874c027ca567cbaf8ad73c5f7097304e7fdcd08f05d10eedba7"
    sha256 cellar: :any,                 arm64_ventura:  "36fef77d65663874c027ca567cbaf8ad73c5f7097304e7fdcd08f05d10eedba7"
    sha256 cellar: :any,                 arm64_monterey: "36fef77d65663874c027ca567cbaf8ad73c5f7097304e7fdcd08f05d10eedba7"
    sha256 cellar: :any,                 sonoma:         "c4f98a4ef54de8b2eeb5133d380967615afa1248669e873d2c6f87a65dc6e54a"
    sha256 cellar: :any,                 ventura:        "c4f98a4ef54de8b2eeb5133d380967615afa1248669e873d2c6f87a65dc6e54a"
    sha256 cellar: :any,                 monterey:       "c4f98a4ef54de8b2eeb5133d380967615afa1248669e873d2c6f87a65dc6e54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0cc4f5787326d3ba8af495ad39854cc74deb4f83aa6b62cf977510e90f2de54"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
