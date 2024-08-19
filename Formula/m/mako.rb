class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.2.tgz"
  sha256 "5b56daaa12db6671321ddc7b7fd788d76a1d675b5ff11919d33b99bda3173dc6"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "751180a0dc502227f6c8f407c2bcb3e8c85abd48e9cd677827197b0213d48c3e"
    sha256                               arm64_ventura:  "de8586cbedb904a41b2d95e4e3e5077e96537bca4169ae1ab0a9c810a61c020c"
    sha256                               arm64_monterey: "739503679fb3debaeb3be9b106fcc00061867d467dd9661972f4aa73c24fe1d5"
    sha256                               sonoma:         "b46603239178a9b01b11bfb3cb80f4294cbf6c0e1186e55be98a746e0b36ca19"
    sha256                               ventura:        "afd525e323cc0cefebdccabd6644f9b9eeb910051c7f57067b555778fd1c0736"
    sha256                               monterey:       "26cf20e6b55d61b158877409e915d87f69a86a96ec015de22822bdbc104fe8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6015cceb0a28ad53d669e43e492acaf74834f714c9d1931c47d35b9c7a10ff63"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
