require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.1.0.tgz"
  sha256 "2975513a166ad52d45b635fa6779999ee3993b224232bbf220390c335ec611b8"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "7f30532370b09e295ef68455f134ab3abfecd75c7493dca83c2f21685558f6f7"
    sha256                               arm64_big_sur:  "f2c15f3bd630151420a8da26a5d4f65560f1e3e291fcb53a4a57c4352c7ab37f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed82c477f57d7577e928fa0d99d3405ca1f5325e6ffddcc4060fdffb8c80054"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ed82c477f57d7577e928fa0d99d3405ca1f5325e6ffddcc4060fdffb8c80054"
    sha256 cellar: :any_skip_relocation, catalina:       "2ed82c477f57d7577e928fa0d99d3405ca1f5325e6ffddcc4060fdffb8c80054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2b968c4237d902e7fd5438835a2f7e334caed63318e5a793d22fab4ae102f3"
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
