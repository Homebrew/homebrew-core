require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.4.1.tgz"
  sha256 "7575e9fca85ddc2590aa26e5c8bc89074c2702147ebe575e5974f1bd22a35b73"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "b031a9caeebbd8b5ab4a4956b70dda97681c2db8b85859f1a1876593288b8ee1"
    sha256                               arm64_monterey: "7604cbc3d7e2d5e86b42a3d88a3fc5d2ba24f6f1159606b6a5ff4de79a5786f1"
    sha256                               arm64_big_sur:  "2d63c1f8f0b56806ab7b68e0c1a114f40bf829ab5fa62876b13c4c798219b36f"
    sha256                               ventura:        "5dd0aa64e4492ba2db046b54bd614efc6ab54fd9f7b1bbf10c9b103b385172f2"
    sha256                               monterey:       "6e7b591f8f85d873fadd764d6a704dcca6ed71785eb71a66f5af44b7f7d548df"
    sha256                               big_sur:        "cea00f5d10336ae71451f09eb355cfd1c794d45b0243d1cb50085ffd28a41677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5062cebd0a99c88dcf7124718a28921f2ebafc4ba898775031564e86a085a9f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
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
