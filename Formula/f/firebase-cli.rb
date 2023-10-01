require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.5.4.tgz"
  sha256 "13f0cce098b4b51a280da9f1aca2ac43053d5da51f5f96a607b33bcc41840928"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c725605323a953ce94528906bd9d917aef9e7d25e7f401c3a73b22ee79d0c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c725605323a953ce94528906bd9d917aef9e7d25e7f401c3a73b22ee79d0c8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c725605323a953ce94528906bd9d917aef9e7d25e7f401c3a73b22ee79d0c8b"
    sha256 cellar: :any_skip_relocation, ventura:        "108d78b8a7f8a4ba6c7287eeff8f56a6cb994544ba726a9567986eb296967237"
    sha256 cellar: :any_skip_relocation, monterey:       "108d78b8a7f8a4ba6c7287eeff8f56a6cb994544ba726a9567986eb296967237"
    sha256 cellar: :any_skip_relocation, big_sur:        "108d78b8a7f8a4ba6c7287eeff8f56a6cb994544ba726a9567986eb296967237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c50a09845df6a76cb46439064c924a33e6b6f39821a60af5ea5ce4608639f0"
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
