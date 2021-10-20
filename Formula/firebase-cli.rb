require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.20.0.tgz"
  sha256 "c020172561aed67bfc37573dc048a057490bb79dee7a8f1a055b5c0a3303cd63"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "5b7d9344298b8ffb367bd8da19618f68689c83767429b8da20db4f76c8d9f451"
    sha256 cellar: :any_skip_relocation, big_sur:       "19aba8b9f38fef6514f3ea73224d899f47a23f315d32ea4ee608dc165c5a438b"
    sha256 cellar: :any_skip_relocation, catalina:      "19aba8b9f38fef6514f3ea73224d899f47a23f315d32ea4ee608dc165c5a438b"
    sha256 cellar: :any_skip_relocation, mojave:        "19aba8b9f38fef6514f3ea73224d899f47a23f315d32ea4ee608dc165c5a438b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480a4ab8ace2370f00e4b808b6945746e307587893fa5cab8562c76757a2ba58"
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
