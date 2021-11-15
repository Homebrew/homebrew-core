require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.22.0.tgz"
  sha256 "aa71568ee27d0e31ce60c49c5b9c1ce8cde0528e31a0d09b7446ba5b12ee3c9b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_monterey: "7ade9c38e59fc852129c796e9d713df3d0867a54f33e3df39d9fe34d2b08be1a"
    sha256                               arm64_big_sur:  "a70e4df99674f33df5387d8d4d60b75a228d4559c597106b31ef34d3632192a6"
    sha256                               monterey:       "0f35fe4257b63e583d78e9c85d2388f73963d9806fb9e661fc894080354054c2"
    sha256                               big_sur:        "3415fa9201a3236c6f1a7f83bfbcd3ceac61fe0d754d57f98881f4af31ba97eb"
    sha256                               catalina:       "f8d58569a57707f6e4aaa7c89c7dc25a23e620009c7c092bf12104eac4461b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e828e96742256491395b5c0ad7084abd3c9e1f3f4a9996835d5c907b229ae62c"
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
