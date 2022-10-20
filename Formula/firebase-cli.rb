require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.15.0.tgz"
  sha256 "3b9d1619849be4e585d1759a21f9192353499df64cb1d827946328a21e377789"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "58147a42accd561914cc4c9f8df2afd6655461ea9a4211cd641aa93ba8f6d291"
    sha256                               arm64_big_sur:  "89fe17d0e48d664f930369752fc881f8571408c2135c1005fd5414aaf1fefe97"
    sha256 cellar: :any_skip_relocation, monterey:       "42a14c4bcd3feff165db0aa8e271a66c871cb8d841d13a2321b8e7ed637d0b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "42a14c4bcd3feff165db0aa8e271a66c871cb8d841d13a2321b8e7ed637d0b66"
    sha256 cellar: :any_skip_relocation, catalina:       "42a14c4bcd3feff165db0aa8e271a66c871cb8d841d13a2321b8e7ed637d0b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db61d56e423204fd2c43a44de5149d93735bd9ea8298d8b42a043560a8593b1"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
