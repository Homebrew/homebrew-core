require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.16.5.tgz"
  sha256 "fb8b8910944bff6af6535ea00d762203b4d81749c82e37ecf9ffdc9d3ef37ff9"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "3b2b692eed01ad3880557bbfb9df49eda402ea7b8cde95c98149e56b2c8dc7b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3dc152b35da67fe5a6d7710cc481dbef082377ac35236cf67ca48b65bf615a90"
    sha256 cellar: :any_skip_relocation, catalina:      "3dc152b35da67fe5a6d7710cc481dbef082377ac35236cf67ca48b65bf615a90"
    sha256 cellar: :any_skip_relocation, mojave:        "3dc152b35da67fe5a6d7710cc481dbef082377ac35236cf67ca48b65bf615a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9f91b73164ba6a6092fed0948a1cc971340b17534c7cd120303b097fef18f7"
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
