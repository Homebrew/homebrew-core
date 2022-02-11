require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.2.0.tgz"
  sha256 "81b7d55a7b16f5b5df76831a9679ee6abcf186c16aadd968da4a0876e25ad58d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "a9c559c7dede9925b8676be2fd8cfa0cda5f2e338dbc3871dd70dcd99d08129c"
    sha256                               arm64_big_sur:  "1fd130e1cbf52e55cfa7a1d50be6298071aa4cb7ae3f6f226a853bbc22fea880"
    sha256 cellar: :any_skip_relocation, monterey:       "085f7ea779c961b473c1fa7c141f8f50f8bd4ea262b2f41d5192fec2ba76458d"
    sha256 cellar: :any_skip_relocation, big_sur:        "085f7ea779c961b473c1fa7c141f8f50f8bd4ea262b2f41d5192fec2ba76458d"
    sha256 cellar: :any_skip_relocation, catalina:       "085f7ea779c961b473c1fa7c141f8f50f8bd4ea262b2f41d5192fec2ba76458d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae7c4c96def3b7069a7866ef69a4afbb5a8b76d734960135a552a4660231d179"
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
