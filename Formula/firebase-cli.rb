require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.4.0.tgz"
  sha256 "ed65d771780e4f69277485a7be8958c2673014000e6af9405d7cedc82d90b6ab"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "eb183768c7b7cb36e3c785abf80379883a5d7537ee824f8c4d1bdc5aca864ced"
    sha256                               arm64_big_sur:  "994d31c3c3007764493181814235e67a71cc224af4af62af3b9a49700439b4be"
    sha256 cellar: :any_skip_relocation, monterey:       "95a7053cf2aaca4d4d9e12ab95da19c1aec34487db5a836b96b67563c1707cd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a7053cf2aaca4d4d9e12ab95da19c1aec34487db5a836b96b67563c1707cd3"
    sha256 cellar: :any_skip_relocation, catalina:       "95a7053cf2aaca4d4d9e12ab95da19c1aec34487db5a836b96b67563c1707cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b0ea44915031fbd5d0bff1d014844cafd5d441d978b85e14c66c60708da0a5"
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
