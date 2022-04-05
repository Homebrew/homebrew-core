require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.6.0.tgz"
  sha256 "0698964ba92789861b79211b9fca6e8269b0d114c356a302e277775678a30fa2"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "0d6936cd4cd5d2ded711f086169f5543f151aa8cded1d0079f0116bc7600a009"
    sha256                               arm64_big_sur:  "ee726ee6fa730375d0f360e8b73460180284a7a21c0e72dbe6fb7601c0fd005c"
    sha256 cellar: :any_skip_relocation, monterey:       "b3585eeb65b5b89af0cdc8aaa3274e5eb56248d55bc7e5c1a265269385c3da9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3585eeb65b5b89af0cdc8aaa3274e5eb56248d55bc7e5c1a265269385c3da9a"
    sha256 cellar: :any_skip_relocation, catalina:       "b3585eeb65b5b89af0cdc8aaa3274e5eb56248d55bc7e5c1a265269385c3da9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e04e26d68d90f35d722e76eeda5a7448ab0c8c3477f3509e2efead63fde334b"
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
