require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.6.1.tgz"
  sha256 "188e1e7b4dc5e926248b335e03bd25649db124af29d0ce69b52680d467e67cf6"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "6a330be841d0c0db1db5d57275a08b9ca5d5318eefec605d62478004741e3c44"
    sha256                               arm64_monterey: "459d69e95582e7bfad0b5b8a696acc4e541d52bbdf3ce39cd6abbe7ba1a73a2a"
    sha256                               arm64_big_sur:  "8bcbf2461214d17b2e9d96df752f38245ec45634ebec395d852a1e99dcd7885f"
    sha256                               ventura:        "9eac4d5be0d8adc8759a2d74b12e7916c7f440bdd64e0623393bd7a83d62b1fe"
    sha256                               monterey:       "d45af0f9bedf5445d7083edb7817241a0d030185c9cc2329f7ff3b2a043ab696"
    sha256                               big_sur:        "5afacfab0f6144ab59eff30d4b4c0a25e29024dbb77b21dc293ca2afd239b1b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa99655924256a083e486f33c9557305ed4cf0da5b114a3c5f4a591d377b3dc9"
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
