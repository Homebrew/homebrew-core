require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-8.0.1.tgz"
  sha256 "a634f5df5d40e0d58957859513e63996825cf2c34abd69d75faee9cac314bc7f"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "7f8ed5f5e63cb4401b38e24022c1975b9cf9836bdf73ee555d5b23c9c99d575c"
    sha256                               arm64_ventura:  "52f535087bb1ad1460eb9f23797affd9b50cef669a91dd304da4adf6e626a45f"
    sha256                               arm64_monterey: "40b3a8291359505676d8e03679e4079d660e00996d7d27cf152273ab8613ff0e"
    sha256                               sonoma:         "1d8b725f916cde2e0b0a70cefb5dfd8f5af60944d40448b04b548da30c5b29b8"
    sha256                               ventura:        "b074204d04d894738d02fb1c7e75650f6ee2581ef25bde49c2fa6054327f501b"
    sha256                               monterey:       "6b30b810fb38c53f5f79068d2c425dd41ac54c22a63993d4f4f1676564c7544b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "295dbc81b96acd2ef029ad6c53facca28c4c10a021eb09a9503c3f106d09435f"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/dicebear/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath/"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end
