require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.1.5.tgz"
  sha256 "e8f1cd91b80a9c39573ccff16cff9f1080030188c28c8584463bcfe4aea57195"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "99ffcda43fc22241174be3f7f120d334b41f2e129691ac34060d4c50e21af043"
    sha256                               arm64_monterey: "758870af1de6389678da093d4d57e2aa33b129fad9e20324291a5e170ed47d64"
    sha256                               arm64_big_sur:  "3b9705ce8db5f915866f8b31ff2529b070c5d27b4dd11eef649fdc0d52b376c6"
    sha256                               ventura:        "0936b9b7ea6411ce948cfcdef610efef51ca5102c4e7d0b624b0a8740d174e1b"
    sha256                               monterey:       "ce59ba9821ee0e1e439fc2701c062ffc12093e6ab8c961661eba5e1a61095f49"
    sha256                               big_sur:        "0808fd97ba54500c4bd22d6d80313b9843f920f2da7f4c3ad63458c2378c6b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "070ddcf279b460e386de85fab21179a8d154d80ea9267e203a5b52fdc2e750a7"
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
