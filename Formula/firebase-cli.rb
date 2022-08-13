require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.6.0.tgz"
  sha256 "0b05c894c693dbdde1dd21bea80a7efb4f4119513120fa95bd694613f65d1086"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "e45574334fb3b8654d22587dc46dfc00f2d2df37b54d792c4cbfb7dc1fe0d678"
    sha256                               arm64_big_sur:  "cc10edeefba296f03070900a8b7b1152917f24eadb23afa157a0665cd95e5e30"
    sha256 cellar: :any_skip_relocation, monterey:       "7e8e4d2fac3b63f1edd6ae0a08d7f0d3eefe622936038a8f4fcc9aeefd4f492f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e8e4d2fac3b63f1edd6ae0a08d7f0d3eefe622936038a8f4fcc9aeefd4f492f"
    sha256 cellar: :any_skip_relocation, catalina:       "7e8e4d2fac3b63f1edd6ae0a08d7f0d3eefe622936038a8f4fcc9aeefd4f492f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f7445b1360a375d6594f9cbb8d6a88d54f5fbcd96a76b31a45eb0b2b5634a4e"
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
