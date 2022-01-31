require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.1.3.tgz"
  sha256 "d2d0769593bb4e6bbcf5b13f06bbe25a213df19bbe69deba6fcdb874e6b2e84e"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "0dfd169f923040e09f11738129086a395225d9d102bed92439d4309d133101ec"
    sha256                               arm64_big_sur:  "96ad934140969fec5dc7e1c6bf332119dbc83893fec6c18d57e4988f87df8c29"
    sha256 cellar: :any_skip_relocation, monterey:       "36294631dc99d03bf16db134cc6b45350e2ba1c2df87342e12328e55865a6a81"
    sha256 cellar: :any_skip_relocation, big_sur:        "36294631dc99d03bf16db134cc6b45350e2ba1c2df87342e12328e55865a6a81"
    sha256 cellar: :any_skip_relocation, catalina:       "36294631dc99d03bf16db134cc6b45350e2ba1c2df87342e12328e55865a6a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a7a0337df9cc0ddb51a17e788755f29e1d8bd247182838f0cf0abb143b5a9a"
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
