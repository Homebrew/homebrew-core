require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.0.1.tgz"
  sha256 "0f8f14addce37cefdf215bd9b851cffa69cc691562e16cd265d85e803e4a2d2e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6921b0f7862d395156272b5eed9d932844cbf3d12f9064c4400586aacdfe6da7"
    sha256 cellar: :any,                 arm64_ventura:  "6921b0f7862d395156272b5eed9d932844cbf3d12f9064c4400586aacdfe6da7"
    sha256 cellar: :any,                 arm64_monterey: "6921b0f7862d395156272b5eed9d932844cbf3d12f9064c4400586aacdfe6da7"
    sha256 cellar: :any,                 sonoma:         "e0ae3fb8bd3dde33fdd3c8d59f086c31c89d4afff54f0f4c84e3bbde518320f8"
    sha256 cellar: :any,                 ventura:        "e0ae3fb8bd3dde33fdd3c8d59f086c31c89d4afff54f0f4c84e3bbde518320f8"
    sha256 cellar: :any,                 monterey:       "e0ae3fb8bd3dde33fdd3c8d59f086c31c89d4afff54f0f4c84e3bbde518320f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46d558d8ee31066597114025922a9889d909a517b4f7e3c93c7a0db4c33496b0"
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
