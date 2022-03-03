require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.2.2.tgz"
  sha256 "28f901a521d2240d7c7aa59842c91fe37c2cae7f6cb70e3c3a434aabbfae68f5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "191b03872c12cde2bd4a226185a6981515092c668893aad4dcf20b3b4a25edbd"
    sha256                               arm64_big_sur:  "d3e0f97c7f84f0f00bb213971aa399c9c349529517d4f0a25f957cb93e2964e7"
    sha256 cellar: :any_skip_relocation, monterey:       "b52d917508d63e270dea73147f1245b3e9f1a9003b663ff3c3ee0fc5a4f73f7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b52d917508d63e270dea73147f1245b3e9f1a9003b663ff3c3ee0fc5a4f73f7b"
    sha256 cellar: :any_skip_relocation, catalina:       "b52d917508d63e270dea73147f1245b3e9f1a9003b663ff3c3ee0fc5a4f73f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6636904dba87fe16f00716eb80b2ba7060023be046a7b4233cd25e8a6c9be6fe"
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
