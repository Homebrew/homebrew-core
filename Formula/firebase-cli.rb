require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.4.1.tgz"
  sha256 "88394bdf490190a2ef2d413073d72dc685222fd112546e220fca555b22db17f1"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "0ac677ae96ac7f77ef61d726b4f6ab67530d446b9dbf8ed5f8d19f3e0c222a97"
    sha256                               arm64_big_sur:  "81e320d3c9669369a6df7c009ca6c834996526ba9509cc73f5598531850f8ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "2c4627af7ba12e4df9d88a3dee4f0230fcf785ae2e71467c262cc3c2f98a2990"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c4627af7ba12e4df9d88a3dee4f0230fcf785ae2e71467c262cc3c2f98a2990"
    sha256 cellar: :any_skip_relocation, catalina:       "2c4627af7ba12e4df9d88a3dee4f0230fcf785ae2e71467c262cc3c2f98a2990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d560f3c28ca4c830dc892af495c18aa957cbcde0834a0000c169710d478a4a7"
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
