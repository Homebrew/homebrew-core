require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.5.0.tgz"
  sha256 "50b9d6d5a820ec30bda68de3bc459b0e5ac560119b0435834ac57356ca416adb"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "a2611e764b4e660935a5acf6b8a17173ac83c1b02cff98bc71936aa54932056b"
    sha256                               arm64_big_sur:  "16e7204080ec3c732cd4208ad72c6ffdd318f7a2f296c17a38501e0af971599c"
    sha256 cellar: :any_skip_relocation, monterey:       "48f82555d89420c6817505659f68392cb3f23e61b2c3c56b1cf2561ee0a3cff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "48f82555d89420c6817505659f68392cb3f23e61b2c3c56b1cf2561ee0a3cff3"
    sha256 cellar: :any_skip_relocation, catalina:       "48f82555d89420c6817505659f68392cb3f23e61b2c3c56b1cf2561ee0a3cff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b945411808545246785a8850b706bd620e0799056a4fbde1c3ecdc7ce84feaf"
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
