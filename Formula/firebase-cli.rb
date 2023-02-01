require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.22.0.tgz"
  sha256 "69f04a4e9e5ca418a8f049ea8167068e0dfdd65a5be875a468d7dd9ee1df6062"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "1b6f89edc004b51d02a78bd525b727486e420a17e9cc4a00e1f12ef6ff4878c0"
    sha256                               arm64_monterey: "6392b0ead403d435241101796bcd10981e9912d67b89d383d0e07f5d16a55719"
    sha256                               arm64_big_sur:  "f5da7a5cc53f6d6300ff405eb04423c3b6ebe2bd96bcf903338f906168c63fe8"
    sha256 cellar: :any_skip_relocation, ventura:        "efaf02390be9d45ca8db6d0a9813db6e7a6a13c72a6ecb7d13cc3afb04190243"
    sha256 cellar: :any_skip_relocation, monterey:       "efaf02390be9d45ca8db6d0a9813db6e7a6a13c72a6ecb7d13cc3afb04190243"
    sha256 cellar: :any_skip_relocation, big_sur:        "efaf02390be9d45ca8db6d0a9813db6e7a6a13c72a6ecb7d13cc3afb04190243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e02327f86d4005cd5c5eed0e37204bff0ce81f6c5feb5489debb8a8f0d2607ea"
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
