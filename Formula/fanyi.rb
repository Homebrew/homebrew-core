require "language/node"

class Fanyi < Formula
  desc "Mandarin and english translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-6.0.1.tgz"
  sha256 "507676c5a45579c6b3d4d5607cdc0d20bd770920f19e4ffad136cdfc69d04903"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb55cc60b3dbdb87a7b2a15c85720aa24dc4224e23abf31f274afbfa1bb2c6d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb55cc60b3dbdb87a7b2a15c85720aa24dc4224e23abf31f274afbfa1bb2c6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "9132b37bc566652a53ca40dbc25435a328d9d649ba9efcad1d5e8650752e23bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9132b37bc566652a53ca40dbc25435a328d9d649ba9efcad1d5e8650752e23bc"
    sha256 cellar: :any_skip_relocation, catalina:       "9132b37bc566652a53ca40dbc25435a328d9d649ba9efcad1d5e8650752e23bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "106b35e5c02b9feab24cd37901b0b6d1ea21136b6888209a88900c0e21f90386"
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
    assert_match "爱", shell_output("#{bin}/fanyi --no-say love 2>/dev/null")
  end
end
