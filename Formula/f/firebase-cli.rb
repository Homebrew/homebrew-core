require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.6.0.tgz"
  sha256 "764ccae36c07b1b00f78d545a4bbe3a946498c6cd376d7b5299db134da0b1ee3"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ebf557271f89b6e6d65550acd48e0f212d22ef105037e7abd7c4e4a9cd4f785"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ebf557271f89b6e6d65550acd48e0f212d22ef105037e7abd7c4e4a9cd4f785"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ebf557271f89b6e6d65550acd48e0f212d22ef105037e7abd7c4e4a9cd4f785"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfb4acc8c8fe7c37a1345a438a25290f17e5837e57ae83171626c0bff67bb336"
    sha256 cellar: :any_skip_relocation, ventura:        "bfb4acc8c8fe7c37a1345a438a25290f17e5837e57ae83171626c0bff67bb336"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb4acc8c8fe7c37a1345a438a25290f17e5837e57ae83171626c0bff67bb336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5a4e92a1a2588dc4b6b159f52055dafa27e0f5efa682fc39f27ad8489ca4025"
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
