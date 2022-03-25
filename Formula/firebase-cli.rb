require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.5.0.tgz"
  sha256 "50b9d6d5a820ec30bda68de3bc459b0e5ac560119b0435834ac57356ca416adb"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "31860b47b094f2912132f52f72059a446145bf159f77f4e314ec3344be033d92"
    sha256                               arm64_big_sur:  "059bf4184a8746aa6901c75ce0d335dc979fb1e30336faa985460fb461aa70eb"
    sha256 cellar: :any_skip_relocation, monterey:       "5e19ff6f72a91a5c65a8a567997523ce9d09bc052f6ede02082c5f90b79f0a28"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e19ff6f72a91a5c65a8a567997523ce9d09bc052f6ede02082c5f90b79f0a28"
    sha256 cellar: :any_skip_relocation, catalina:       "5e19ff6f72a91a5c65a8a567997523ce9d09bc052f6ede02082c5f90b79f0a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a1f01096e6283e089d94726ce655441ea5e306ff3012d00da2eae3dce5f557"
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
