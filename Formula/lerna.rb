require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.5.1.tgz"
  sha256 "05288dbf9c3fa5523d68ad04e80f69ba88c8e4f00b68c03bb990202d4341ea20"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "9f8c4bb0c4f655027abe3d527300c88dfac54a743074fad0eb96174638f5095b"
    sha256                               arm64_monterey: "741f6dfab6ad999734d43170d71fa987eeb8ba5e00583b15154e5c91c131a346"
    sha256                               arm64_big_sur:  "6ca426cef9d2eb647bf166f3548c8af112e8385a5f99d86fdb3025135474cafd"
    sha256                               ventura:        "d81db78e9092845516c90f949b93d94242710becba4295f95d47bf4e138990f8"
    sha256                               monterey:       "d0df37d822ddb2655dbd9a6959755474029d72d7551fd80d05c4359295b3141e"
    sha256                               big_sur:        "ff5e6b6ea17b465c02b37ca3921266ef1e2817072ebd672694bd4d3c3b4aef83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f5694c27785e4510cc41ee4fcaa9a12925c2201c2cfa652a63b72243cdc079c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@nrwl/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?
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
