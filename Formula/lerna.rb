require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.6.1.tgz"
  sha256 "188e1e7b4dc5e926248b335e03bd25649db124af29d0ce69b52680d467e67cf6"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "c6b013fe419d17943e1f42ca9205bd9f5a8c46abd1f0f1ffb313aeb58bac24e3"
    sha256                               arm64_monterey: "fd9ffcfbe08a08059eb896e28b628f7520bdd24ab7176218d117d99f3d6526da"
    sha256                               arm64_big_sur:  "5ac0239254c79eb64ea082f347e78adef08eb7a8f4a3160a5ab2d146fbabbd64"
    sha256                               ventura:        "81c60f076cfbe982d6624d9fb3aafcd25c8a9d0d7f21f4ba9336731db2dc7b71"
    sha256                               monterey:       "c799586befce788f899d3d1c755c6ee50a9ad6d629f800572cbf1c1211b66acb"
    sha256                               big_sur:        "bcef26953ca5d9c9b760a3d439174b8955e1d75dbe988ae9dbce523c06c5a0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8823ef6193e91f6fe31d943c1b0e50e483dce4e9a2f78e544d081c48f444a9"
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
