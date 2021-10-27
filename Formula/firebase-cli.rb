require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.21.0.tgz"
  sha256 "1dc42fe2a7e271190b64ee77bab83f70ea59d8180ef524b766fa9440a775661c"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_monterey: "7eaafc1588d5c216012c54f5c910c897184e8c62bb667df41d915eb8b4f4348f"
    sha256                               arm64_big_sur:  "67672aadd14268b9e1bb2195feb5af811d58d7fb4ed2d23da23ea8be1e6de59c"
    sha256                               monterey:       "48a0a3bc7c1fbc8babbec3f4e80b06f551cf68474bfc092626ac743c808008f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6cb574010fff188988e306b0d3a37f5cda65f70f613842256e9fe93011c79e6"
    sha256 cellar: :any_skip_relocation, catalina:       "d6cb574010fff188988e306b0d3a37f5cda65f70f613842256e9fe93011c79e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c195011968f65a9a6684c6318191dc3be742703e39ab19d518348e381811bdcb"
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
