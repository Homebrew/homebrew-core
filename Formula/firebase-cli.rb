require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.7.0.tgz"
  sha256 "de13de9a780545bef52c9720070934e244dfce655e81a2dbfdb647eae1e19130"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "7ebc1b287593176fc7a18c0ecf4c3e4fb223e75ef2e855594b5b2fa4fba65fce"
    sha256                               arm64_big_sur:  "49fe33f14405a1a09fc04f41d006fdef2c817bcf029a427da3bd4039cd2d8363"
    sha256 cellar: :any_skip_relocation, monterey:       "6d531fa2da43e28d588d7c6e1b6f805708a55a893e2d5ca858c2615a09aaf669"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d531fa2da43e28d588d7c6e1b6f805708a55a893e2d5ca858c2615a09aaf669"
    sha256 cellar: :any_skip_relocation, catalina:       "6d531fa2da43e28d588d7c6e1b6f805708a55a893e2d5ca858c2615a09aaf669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9db9c315f6f0666b20a82393f28bec391eb1acb70eaa0d81ea496ed6462b9d8"
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
