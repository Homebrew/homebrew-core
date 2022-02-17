require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.2.1.tgz"
  sha256 "0c9155b3a0d42ad1515218bea3abbc5033c5a3fae52e798d3bef957c9147533c"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "39645fb8e5d5d5d0e988cf73ad544f8120ec92aed1a900253a801ff03817d4a7"
    sha256                               arm64_big_sur:  "80c5bf4165064744f82bd04e8a654a30872f110cf0a9e14471f2942f8653b510"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2711525fb40c0e24ba2b7576ed0a26f7f7c13333b1c8425077dd5eba1c8e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a2711525fb40c0e24ba2b7576ed0a26f7f7c13333b1c8425077dd5eba1c8e74"
    sha256 cellar: :any_skip_relocation, catalina:       "1a2711525fb40c0e24ba2b7576ed0a26f7f7c13333b1c8425077dd5eba1c8e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90c04b1a72448937016de7f6af239313b906cbc80f196658a65eafc37eccfaaa"
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
