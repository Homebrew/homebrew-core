require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.0.1.tgz"
  sha256 "cfa57ac33a7b81e923ab3712fa5e0c10cc4c514294a4d1aa77442bfca5525df3"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afaf0369360eb7c072a3ef5c0acdc232fd8ab6e4a3c0a63b7fbcc4797119dc76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afaf0369360eb7c072a3ef5c0acdc232fd8ab6e4a3c0a63b7fbcc4797119dc76"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0660812e3575809a192223c0f1ccd8e9c7044f7ce3a97fa261a62c68ee3b44"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f0660812e3575809a192223c0f1ccd8e9c7044f7ce3a97fa261a62c68ee3b44"
    sha256 cellar: :any_skip_relocation, catalina:       "2f0660812e3575809a192223c0f1ccd8e9c7044f7ce3a97fa261a62c68ee3b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e78107619338a31bf513b3256a79da295a92b739b1d473436ec4c647259f75e2"
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
