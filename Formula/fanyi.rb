require "language/node"

class Fanyi < Formula
  desc "Mandarin and english translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-6.0.1.tgz"
  sha256 "507676c5a45579c6b3d4d5607cdc0d20bd770920f19e4ffad136cdfc69d04903"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d188a42a8dc37ac2dfb24907f4e22981812057cfe075e16bb2492fa335ca0c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d188a42a8dc37ac2dfb24907f4e22981812057cfe075e16bb2492fa335ca0c9"
    sha256 cellar: :any_skip_relocation, monterey:       "cbb484f9b97e1493a1812a7174f4fd6314aa658f5e5e8512fe079e615b0ab7da"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbb484f9b97e1493a1812a7174f4fd6314aa658f5e5e8512fe079e615b0ab7da"
    sha256 cellar: :any_skip_relocation, catalina:       "cbb484f9b97e1493a1812a7174f4fd6314aa658f5e5e8512fe079e615b0ab7da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e52f1d36fcd008e52de4a7564dfbc7de75ca0f92ccf37156d50bad475c9e50"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi lov 2>/dev/null")
  end
end
