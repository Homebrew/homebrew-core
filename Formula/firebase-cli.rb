require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.22.0.tgz"
  sha256 "69f04a4e9e5ca418a8f049ea8167068e0dfdd65a5be875a468d7dd9ee1df6062"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "c993a87d8590e0cde888b44c0214e455d7937fdeca2f182704b567def4f50f8e"
    sha256                               arm64_monterey: "5b9aab3edb119a35130d03a887c57209eb8771522400f504920f7494c73b5915"
    sha256                               arm64_big_sur:  "f1d1df1a9247fcd80f0ccaf2255e0ddf2b9120e1c3c574c41be2da3d261b90fd"
    sha256 cellar: :any_skip_relocation, ventura:        "4b2ece6218dc65e6461d6f7b883a07843b69220a2b7f4a2c73321a0f0ad57789"
    sha256 cellar: :any_skip_relocation, monterey:       "4b2ece6218dc65e6461d6f7b883a07843b69220a2b7f4a2c73321a0f0ad57789"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b2ece6218dc65e6461d6f7b883a07843b69220a2b7f4a2c73321a0f0ad57789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c119fcc5d1be2eccc4900fd46e84ec5ee5ed1ddf170d6d57eaba20a2ace60d67"
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
