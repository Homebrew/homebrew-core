require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.2.2.tgz"
  sha256 "28f901a521d2240d7c7aa59842c91fe37c2cae7f6cb70e3c3a434aabbfae68f5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "707c8128f2f08de82f995e10672a1a8885f1839904c729f200dbc45aa9dc0e2c"
    sha256                               arm64_big_sur:  "e2700f369aab7699ef3c76af5f8bf32553c06d0aba691a8cc7fa901027020486"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd89fc402fdb0be8f994ace877144438cd00d8e606b822e65e7ea98b8094fd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dd89fc402fdb0be8f994ace877144438cd00d8e606b822e65e7ea98b8094fd6"
    sha256 cellar: :any_skip_relocation, catalina:       "9dd89fc402fdb0be8f994ace877144438cd00d8e606b822e65e7ea98b8094fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cef6f67f357110c3a39f1e9d8e6f593636e2c1169b058d19baab2cd1e0308b7"
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
