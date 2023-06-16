require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.0.2.tgz"
  sha256 "843231ecc712193acb56a22d83291748a59518b52fdc3a6087207506e9290a38"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "6297578194835a097676edad6b5a0657e48dcb089f137a77ee0cd70fdd8ba724"
    sha256                               arm64_monterey: "ca7635a6e4eecd20b418bf0c49b7a9cca21be25d3fe44a464eea2f08ffa69cb9"
    sha256                               arm64_big_sur:  "b9da0c76e6ca2f5570e0770263da134c00964bfc4f2ad953dd7776294c620bd4"
    sha256                               ventura:        "6091ba16b7f4bb47c94b83d3e4cc7fb96281cbe07eec35b0c4cb57646d73e8fd"
    sha256                               monterey:       "2a0e723f2763b04e2dab0aaa8fbc209f38b339e2aab9e107ca584e7b744778e1"
    sha256                               big_sur:        "956c4f23dc89935e0e05125af7c532335142fa57dd96e550d07da337ca7fc9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b369fb537118ca6b01e68ff7213f85d94b11ce45123f98dda6e06f6a6878dd7"
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
