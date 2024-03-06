require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-7.1.0.tgz"
  sha256 "27a3be6cb2013393981941ef346d08d33dba6165141fcd09769e10be95305308"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "be7adb7f40fb9a2ae969004c22f16b3b5076f0fbf3ca0625b2b1898b9ffcb143"
    sha256                               arm64_ventura:  "e727563a757fb812e29c07b4fc16782a55e4ebe28306348f687f319d6a392b93"
    sha256                               arm64_monterey: "6a7630d26d65e848737baf096b74ffd3ae812fdbb1855e47d6785395d3658c8b"
    sha256                               sonoma:         "61e722cdc6a752681dae6a66227e31a0ce2a0b7bc58080f1a77cd94a31e84e7c"
    sha256                               ventura:        "73eb5b0bcb2e61c50d09c48a969b10ad0cebc2df8b2ffae0af09bff8e12c381c"
    sha256                               monterey:       "2494f90d60046e35d881125376031e4acaf823f62f20d8aa600813ae3c78946e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dcea332e8e3ad4ca83a85aaa18dc6f74dac8d3cdf77f3472600e35bd8a27236"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/dicebear/node_modules"
    (node_modules/"@resvg/resvg-js-linux-x64-musl/resvgjs.linux-x64-musl.node").unlink if OS.linux?

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
