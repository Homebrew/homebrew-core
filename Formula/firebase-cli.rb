require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.3.1.tgz"
  sha256 "bd68926378a4a82370656b64caa834c5abf8b93038fea6a8a6c622d38370b8c3"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "a5661b1166048e95e5ed22bf0554c8ab14fca78d26cce4f9a315bb41adf1286b"
    sha256                               arm64_big_sur:  "ccce5205d05870ca90882415732f822437571b343a162e425ec5dd4fa49f456b"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0aebf8c28ec0bb121f13749b1e95896eb7b9c3229f02c2f3ed9e6f18009ec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f0aebf8c28ec0bb121f13749b1e95896eb7b9c3229f02c2f3ed9e6f18009ec4"
    sha256 cellar: :any_skip_relocation, catalina:       "3f0aebf8c28ec0bb121f13749b1e95896eb7b9c3229f02c2f3ed9e6f18009ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25d676f3cac188211f96f1e71c706d5480c1f1aae08168d7deca133bee138e1"
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
