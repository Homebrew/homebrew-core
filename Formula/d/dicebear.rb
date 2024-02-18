require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-7.0.4.tgz"
  sha256 "57dbc1665d44a8f1021898d60056e3334904d1b71ac5a4e0bdbb107fc8bc3c93"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "5b36b0e6c8bbf330ba0dac92e5a5bbead2a26e8c526c9fbd23e4b021b327a206"
    sha256                               arm64_ventura:  "c2393d9d12bf2e88f5711449514971e90e1ddd125dab3b1e9b576e93227afee9"
    sha256                               arm64_monterey: "bfca8acb58992d0f6f54df1c8d4d67086f74ee95bdaf60e656c326865b0f76c3"
    sha256                               sonoma:         "adde3b7f40f612711ff9eb2ef17321fd30486b37eea16d949e4c7c93f9de0277"
    sha256                               ventura:        "25afa61af1ca22efe2c148f05605173c6bf9981eb3fab5d42a71b9b381d8033d"
    sha256                               monterey:       "5d520c5f4d73679228a2b35e843f2084cadb6e8bedbb18e006216b06ec92cdd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fbc59b196768232a96abf1002ddfe00181e8a0676972b64e5868e68fbc9de10"
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
