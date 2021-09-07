require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.17.0.tgz"
  sha256 "0bfd4f6c81e5c4582e67d5c341c85d37bbb0b5f69ff0656b209db2cb2bb83cb2"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "7339fc6effdae86cbe088c0cc85c7d3fb68f88c4d6287d70afd617ea1f71a582"
    sha256 cellar: :any_skip_relocation, big_sur:       "f00f910a2dc28d46f99d528c71268d352dcebe8bdefa7cedae5b230db5b97f78"
    sha256 cellar: :any_skip_relocation, catalina:      "f00f910a2dc28d46f99d528c71268d352dcebe8bdefa7cedae5b230db5b97f78"
    sha256 cellar: :any_skip_relocation, mojave:        "f00f910a2dc28d46f99d528c71268d352dcebe8bdefa7cedae5b230db5b97f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4672daf81ff24abc8be5b40c00e4440732eb599c47f1a7713a8158e0733eae45"
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
