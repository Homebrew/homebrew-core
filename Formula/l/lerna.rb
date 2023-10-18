require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.3.1.tgz"
  sha256 "97973a97098a15c675127c099783fdb3cdf7b7c7adf9b2076f73de345cae7e3a"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "ff31e67013c99eb887cf0efd32391af68191f03dc42521bbc52fdd449a7bfa94"
    sha256                               arm64_ventura:  "4c6008d96cdfed3793e3a25d57fe19cdfd278cbd0d60a73e1284df7e78517e32"
    sha256                               arm64_monterey: "71ca149dea9a5c5c0b4f19d90d68a6652e29f579afdeee37c02b81c93848789e"
    sha256                               sonoma:         "c32902cb5ce9b16ab7613296441efb5e3d7d8dda40ae66fb652e306473ca6cb4"
    sha256                               ventura:        "532e8f48913cfd3c5ef71c1bb1b81780729a379fd77bccdf34aa8360d86ebb07"
    sha256                               monterey:       "096b35be28c161a13b49378a9368d63ebd3951768b0345c67eeb99e34e684bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ae519c297a9e27caeb06181292b6f89389f02848b95d4648c71df8da0c1cc2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@nx/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?
    (node_modules/"@parcel/watcher/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
