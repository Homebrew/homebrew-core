require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.16.0.tgz"
  sha256 "3e2b6babb76d8cce1d0785cc8633443bdb8bfa10b91220893cac5c0b5b291fe0"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "d40a12764476ee1b16517dacd946205d33aeed62a17f8eeaf7200e8d4df815da"
    sha256                               arm64_monterey: "58147a42accd561914cc4c9f8df2afd6655461ea9a4211cd641aa93ba8f6d291"
    sha256                               arm64_big_sur:  "89fe17d0e48d664f930369752fc881f8571408c2135c1005fd5414aaf1fefe97"
    sha256 cellar: :any_skip_relocation, monterey:       "42a14c4bcd3feff165db0aa8e271a66c871cb8d841d13a2321b8e7ed637d0b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "42a14c4bcd3feff165db0aa8e271a66c871cb8d841d13a2321b8e7ed637d0b66"
    sha256 cellar: :any_skip_relocation, catalina:       "42a14c4bcd3feff165db0aa8e271a66c871cb8d841d13a2321b8e7ed637d0b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db61d56e423204fd2c43a44de5149d93735bd9ea8298d8b42a043560a8593b1"
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
