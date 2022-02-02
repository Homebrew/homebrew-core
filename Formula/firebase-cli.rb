require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.1.4.tgz"
  sha256 "c240350517b16fdc44da33e76c249319945e04653407405c4a1eef85fbea85cc"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "14fec596493ec941cbc9454af570221fe866691943e07b97fbb7d194ebbb62c6"
    sha256                               arm64_big_sur:  "dd34b399bb53145f118df62b493a6096a86b34f0d754f376915711233f7e0c00"
    sha256 cellar: :any_skip_relocation, monterey:       "5347134ef99e13b359f21cf12d69bbdab5d67af8a2fc48df6aa9ea5d506b71d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5347134ef99e13b359f21cf12d69bbdab5d67af8a2fc48df6aa9ea5d506b71d7"
    sha256 cellar: :any_skip_relocation, catalina:       "5347134ef99e13b359f21cf12d69bbdab5d67af8a2fc48df6aa9ea5d506b71d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421572b1f789db2dd8d7b7bcd65b03e729fdf9621599870ad5f5645a1b59e185"
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
