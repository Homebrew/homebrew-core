require "language/node"

class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-8.0.0.tgz"
  sha256 "0b946e98f7a3d7607c08f836d884be76f24cae0976874e891c5f484e222f4900"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0069db5a3d5c50ff5b17df99f18732890bb1efd60f579ce5b7f0cbe2bb9a8fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb55cc60b3dbdb87a7b2a15c85720aa24dc4224e23abf31f274afbfa1bb2c6d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb55cc60b3dbdb87a7b2a15c85720aa24dc4224e23abf31f274afbfa1bb2c6d6"
    sha256 cellar: :any_skip_relocation, ventura:        "806fd5a63cbb2621d1d462f7bf2820b8f540664b41a0971de63994aa75340aa5"
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
