require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.2.tgz"
  sha256 "269041891d18502be115f34f96af966f74fcceeb8750e1addde49d68541cbfdc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5c71bb2e2ac9b417802e4080524648810494334e65f592b6b96042d60234ab44"
    sha256 cellar: :any,                 arm64_ventura:  "5c71bb2e2ac9b417802e4080524648810494334e65f592b6b96042d60234ab44"
    sha256 cellar: :any,                 arm64_monterey: "5c71bb2e2ac9b417802e4080524648810494334e65f592b6b96042d60234ab44"
    sha256 cellar: :any,                 sonoma:         "1d7dece6b2bcb119bdff3efeb24e6e817f87708509b0f69d0c9579a13a13f045"
    sha256 cellar: :any,                 ventura:        "1d7dece6b2bcb119bdff3efeb24e6e817f87708509b0f69d0c9579a13a13f045"
    sha256 cellar: :any,                 monterey:       "1d7dece6b2bcb119bdff3efeb24e6e817f87708509b0f69d0c9579a13a13f045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30fb2b78c628c706a7886f110bfaa9ae95dfcc7480480e5ece785d98e151317"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@nx/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
