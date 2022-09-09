require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.8.1.tgz"
  sha256 "c09d0c207d6aef9f11f7c096e7d8bad0cc8dff1b4c7ed87205606884a15745d1"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "402395cde63086dafba3bb958f18c953dd6d4dd12d70766527b5a79a93ff7766"
    sha256                               arm64_big_sur:  "c2967fadaaeb15b16dfd0254ccd9b790ecaef3f28b46669db017784995f4010f"
    sha256 cellar: :any_skip_relocation, monterey:       "c44550e68109c918732e420a74b65931d7566c46f5c279218df7ce0c4c9bb2fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "c44550e68109c918732e420a74b65931d7566c46f5c279218df7ce0c4c9bb2fe"
    sha256 cellar: :any_skip_relocation, catalina:       "c44550e68109c918732e420a74b65931d7566c46f5c279218df7ce0c4c9bb2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d471ae36c8a6d53313a2adb5dbac66837e6ba1365d9272c6c3b30664a42086a5"
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
