require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.14.0.tgz"
  sha256 "ffc34614f13cbdbbb0c0d65ce012bbcd12ae7373f31e6489f46daff983b2a7a7"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c3f74924b0aab4fc25c691f535f4a64ee805ddc1473133a68bedf2c5129d2f23" => :catalina
    sha256 "724ac2517fb04dbf1eab77d56bd1567f07330cc7ad4ee9b2a1d0a76983358756" => :mojave
    sha256 "14ea4a09b6910a2fc9d6fe0676755ca4e55aa4570eba74a08916f1569cc77d1e" => :high_sierra
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
