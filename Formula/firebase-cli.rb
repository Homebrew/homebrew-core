require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.16.1.tgz"
  sha256 "149f5f241172b78933dbbe6ce3b8e054ccec31fcf8f824315feb341b21b6af87"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17a163496a015ced51f8190d39869a10cdfde46b741d77c372b4aaad45268617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17a163496a015ced51f8190d39869a10cdfde46b741d77c372b4aaad45268617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17a163496a015ced51f8190d39869a10cdfde46b741d77c372b4aaad45268617"
    sha256 cellar: :any_skip_relocation, ventura:        "d64391f082d399da0b822ced8b3e5b6cdab2b7a829c0fd3c75696113ac8586de"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9c67c38a7757e2894e8dc175c0baa789b30c8e1c29a473d0e54547456d50ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc9c67c38a7757e2894e8dc175c0baa789b30c8e1c29a473d0e54547456d50ef"
    sha256 cellar: :any_skip_relocation, catalina:       "fc9c67c38a7757e2894e8dc175c0baa789b30c8e1c29a473d0e54547456d50ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf08f72d54ad8d00688fea6b111d84b7a8e5eba5dcb4c50fb700f1bd4528649b"
  end

  depends_on "node"

  uses_from_macos "expect" => :test
  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/firebase-tools/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
