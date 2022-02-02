require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.1.4.tgz"
  sha256 "c240350517b16fdc44da33e76c249319945e04653407405c4a1eef85fbea85cc"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "05e7bc1f4014dcfb9a9e196086d742704eaed34367e9b6f1c59a27697ea389a4"
    sha256                               arm64_big_sur:  "bf930698c71988446365a889d0e334a6f2f5e991f5595617535a91619e10ae05"
    sha256 cellar: :any_skip_relocation, monterey:       "1a550acfa99c4d0c417069177656b7ae1762eb3ef5ebb923e810eff69c535ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a550acfa99c4d0c417069177656b7ae1762eb3ef5ebb923e810eff69c535ee5"
    sha256 cellar: :any_skip_relocation, catalina:       "1a550acfa99c4d0c417069177656b7ae1762eb3ef5ebb923e810eff69c535ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87fb3eee4f98809fac348a613db5a0325bd8636b138c5d90d3af47bc00203c4"
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
