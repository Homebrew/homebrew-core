require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.18.0.tgz"
  sha256 "4f972414c9fa0e2918a4a8c66e8437771b58bf94b9399158d1a685f2948d8009"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "8a9cb6aa1d637d1c57bbe21e8e78a8a5a0dce526993aa68ba516287714364d1f"
    sha256                               arm64_monterey: "6b35ba6acd4b22a1b2cbedb6f59737ec6597bca8cba18280766a330f6ccb571f"
    sha256                               arm64_big_sur:  "d3e3b24998f035279c29a52ff0ace7dff7960781ce8778555e38442c04b3221d"
    sha256 cellar: :any_skip_relocation, ventura:        "32b3fb978ec43ef4fb1c1b5b78823782d2d7b0b5b230e69661b6226ea459a53f"
    sha256 cellar: :any_skip_relocation, monterey:       "32b3fb978ec43ef4fb1c1b5b78823782d2d7b0b5b230e69661b6226ea459a53f"
    sha256 cellar: :any_skip_relocation, big_sur:        "32b3fb978ec43ef4fb1c1b5b78823782d2d7b0b5b230e69661b6226ea459a53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db8e33eed98ea8779a2e97b8b622c3424e455abf8e70966f9708f59d6c4e473"
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
