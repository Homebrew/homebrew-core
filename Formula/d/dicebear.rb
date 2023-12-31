require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-7.0.2.tgz"
  sha256 "ff134eb3157fb796b45bf31ee4ac4da416730b8474dccee0af9b5a61e3271006"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "065dd5b58009a12faf4dffa0151c61d55325f783f2ee26f737966a932e0b966d"
    sha256                               arm64_ventura:  "518d14f8c36bda0320bf14c0ce759ec7e1461fa5683b772b28eff1f7a166109e"
    sha256                               arm64_monterey: "270d228255d8b3667537a3202d0c6d4ed72e86ccb91ab9c14d9c47dcd4fe791c"
    sha256                               sonoma:         "e393d80cdb20dd4879e351be15ec8c0141c3f94c0b1e155bcb319b47a08a7cf9"
    sha256                               ventura:        "5f4ea3399de7479aa418f338dfa0cfe929e08a91803135503e715df26b3079d8"
    sha256                               monterey:       "e658b5e4375b923e4c3b2b398607d5f3c3886acaffb4d50057306f09b1be7cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7faf48c46d80df4f113b7501ab42694b845949a1e14158e0c2d1ccd1f1329c"
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
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath/"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end
