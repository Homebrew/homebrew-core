require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.16.0.tgz"
  sha256 "3e2b6babb76d8cce1d0785cc8633443bdb8bfa10b91220893cac5c0b5b291fe0"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "c8ce640b002fc9a24abeecc9897b244e4eddf3174ae8396ae609661775d1dd21"
    sha256                               arm64_monterey: "ac89081ccd6b350ec08d59b5b935fae8d8c62b4bb5b6193a69aca9544e7e87b7"
    sha256                               arm64_big_sur:  "0dbc1bcb68d7b7f65f4899cfc2099573eefebd2d5bcc15bda3db49dade35b677"
    sha256 cellar: :any_skip_relocation, monterey:       "2addc14b700af6e04598e8961227d0af093559c025d63d7dc2caaafbb72133a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2addc14b700af6e04598e8961227d0af093559c025d63d7dc2caaafbb72133a3"
    sha256 cellar: :any_skip_relocation, catalina:       "2addc14b700af6e04598e8961227d0af093559c025d63d7dc2caaafbb72133a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9acc7ec6682f5f6444003457ff0fa498aac6ba18122e0443ee41cd637644516e"
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
