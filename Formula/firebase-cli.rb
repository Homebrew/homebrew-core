require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.4.0.tgz"
  sha256 "186112e9b3d8ec726a4e893f4284145ec138f4dff1932acb8c2813c2e1c2c676"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "1581dc8507c4769a61167e68098bad085fe4e7e5f39e9a0a7af6f07b9c002706"
    sha256                               arm64_big_sur:  "d570ec99b3d226a360dad0959d650a188aaac1e591dd3301cdc74c701e56c242"
    sha256 cellar: :any_skip_relocation, monterey:       "1411b31cef94197120dfa4046442928c975cbad03ce8553cd566a773fc8a4a71"
    sha256 cellar: :any_skip_relocation, big_sur:        "1411b31cef94197120dfa4046442928c975cbad03ce8553cd566a773fc8a4a71"
    sha256 cellar: :any_skip_relocation, catalina:       "1411b31cef94197120dfa4046442928c975cbad03ce8553cd566a773fc8a4a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41422c3dc3722563fc614471e781c3df4f53b599266fbf826f83c8539d2e21f1"
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
