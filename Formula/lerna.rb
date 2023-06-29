require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.1.1.tgz"
  sha256 "deda327b7608d9d518ae89d32fca556015055bcf6fe67efa1a64ad2e63a3c827"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "0deeb3e7ba032a1cd4e7b87bd7b48c7b9ed2e40b39bcd34643ae1392948c0623"
    sha256                               arm64_monterey: "ee4182a9bb49d4ae65e3f156e7765d5d9d2f37a49d7412267af9ffcddb034e38"
    sha256                               arm64_big_sur:  "a6ecc488e0f379eecb6d1d2a195059e6525b35c5dd05f7a63a04fe354f35c8cd"
    sha256                               ventura:        "19bf2fa2c2c867ec3d7cda95c4b629fe5e94a37316bb8843b2df8c1a8efc1e8d"
    sha256                               monterey:       "cfb7f70d97c7197b7e4edc455f2a9314a543816c18dedccd66469fe4ef7b7a92"
    sha256                               big_sur:        "8d5558e3c2367833d42f9dcf1446355513d7bcfd5f67fce92f0d5bbb740274b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e48cbc7c6e915cb96aea72740f20e70f7a808c8eb1d3b268a1fe8b8f45ac84f4"
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
