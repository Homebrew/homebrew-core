require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.16.2.tgz"
  sha256 "c42c3858b63ad93d771621a9e05ec117d8a0ed2af26184a48c117114f72bf668"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "cb8888ba0ddc3cdafd621bc8bc533476a0f2adc8494031af8cc72dc0e9035abb"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c8539d00283d13fe2410c2abbae5fdcf429a6de54b9167157a205ab2999b935"
    sha256 cellar: :any_skip_relocation, catalina:      "8c8539d00283d13fe2410c2abbae5fdcf429a6de54b9167157a205ab2999b935"
    sha256 cellar: :any_skip_relocation, mojave:        "8c8539d00283d13fe2410c2abbae5fdcf429a6de54b9167157a205ab2999b935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638ce46ed15213beb17b9c85fc8d17caca0f8bae90d021065e57c103d6d21c38"
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

    on_macos do
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
