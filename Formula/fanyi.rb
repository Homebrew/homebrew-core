require "language/node"

class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-8.0.0.tgz"
  sha256 "0b946e98f7a3d7607c08f836d884be76f24cae0976874e891c5f484e222f4900"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3b97798cae69975e27a061f026054f8cd6dfa1757cafc053452acfcd833fe5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b97798cae69975e27a061f026054f8cd6dfa1757cafc053452acfcd833fe5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3b97798cae69975e27a061f026054f8cd6dfa1757cafc053452acfcd833fe5e"
    sha256 cellar: :any_skip_relocation, ventura:        "e7f08ad398efd288f8a694566cd41a1d5ebb72a1fa325857e2914bddb8d39c66"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f08ad398efd288f8a694566cd41a1d5ebb72a1fa325857e2914bddb8d39c66"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7f08ad398efd288f8a694566cd41a1d5ebb72a1fa325857e2914bddb8d39c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d6287df9410efbbc1ce7af8d7af3b42fa1218867557ee0a6d5cefe8201ec97"
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
