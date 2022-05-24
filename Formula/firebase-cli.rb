require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.0.0.tgz"
  sha256 "d07d62c59c2b13fb6bc7de6e4815c12b9f7271c3eaa0e966433b4e3d1a0b93aa"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "5676ce9ca995d19d762d5730090fa37cce6283cd459f7f4cbace2c5ac96df3cc"
    sha256                               arm64_big_sur:  "3049d95c32f7c4f2d9de2255f2c94ea20061fe6f95b6355648f1327d67f84743"
    sha256                               monterey:       "e4262a4ffb8707a7b61831dfaa538ff3a6cd01441212b167612daa929a2382b4"
    sha256                               big_sur:        "962501149c1a6c67d09bbc5506be49d4e9245c9fe95a924d64ae73005f7763f2"
    sha256                               catalina:       "82e0dfb4b9817cf8c28667422ba3ba45806196e7206b82a5f6a8cac73a8c55b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "569ed65c64024d17b55fbb7b4660812d9a51d0dacdd4be18f1e254b8c929ffd4"
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
