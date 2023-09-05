require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.2.0.tgz"
  sha256 "e8f52b3d7cc601f31f85b22d5e66977350e8f698fc34023bd8ddd845a09b5443"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "28138789311258723261888890b98faab2f8378e025ba860efce45c7010f8a43"
    sha256                               arm64_monterey: "cea15720e98f58e8f4819c9ea26b82b1daf3efdc2d67b75e99075cc65a04effd"
    sha256                               arm64_big_sur:  "f03262530bcd4538630fdcbb48e8bed02ac1245d4c88620cc5de44b9eb2ffc48"
    sha256                               ventura:        "22e9a97996cf393a9edb1878683f8436cc6fd3666265cc5f06bb053df98eb1d4"
    sha256                               monterey:       "4a4097a254294299d827cfafe1f8b695422156f9b9fba43092dcbf81be5c95ae"
    sha256                               big_sur:        "85837ad06613d00fa4f7410b34f6f7b6a9620f3731a082ade5c4a2fbb0a5a854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "841345c39f41d59837c8e26ffabbc3e07a2a4d81a1ad4d5ba1ec40a0ab71d9e9"
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
