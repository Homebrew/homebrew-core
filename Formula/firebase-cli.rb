require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.18.0.tgz"
  sha256 "4f972414c9fa0e2918a4a8c66e8437771b58bf94b9399158d1a685f2948d8009"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "82c054fd50a02adc11a3a77b1e3a6432e87641508be6aaf7404296cbd4597f30"
    sha256                               arm64_monterey: "06c8cb7b0b090df0521b9b5e1d16941e9dccb77063537f5242c3d6e5aaa5edd8"
    sha256                               arm64_big_sur:  "bb9581730957580b0f7d8e85dedd0ae65aa2027798b8574bd12efcc6eefacfa4"
    sha256 cellar: :any_skip_relocation, ventura:        "17bdc57fc9d649b338d57fd1db6c91d4c5b57d3591421f2708652f294cfae23d"
    sha256 cellar: :any_skip_relocation, monterey:       "17bdc57fc9d649b338d57fd1db6c91d4c5b57d3591421f2708652f294cfae23d"
    sha256 cellar: :any_skip_relocation, big_sur:        "17bdc57fc9d649b338d57fd1db6c91d4c5b57d3591421f2708652f294cfae23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbdb81aa0766f038cc48af6f2659e57955364dc7ec07a3be8b0db80726677c9"
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
