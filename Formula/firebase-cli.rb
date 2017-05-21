require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.9.0.tgz"
  sha256 "24b1e538897c82a8da97b3df0e0322d447194ee030eeffdf0d5718391c8cd0fb"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3630bf4898c4a07d6e605de7585be727f64a4631c652f9065c3a26071c02000" => :sierra
    sha256 "267b398c670469b0f9bebb80ced0e2fdf2350e4a4d37cde4913365d886ec8498" => :el_capitan
    sha256 "e4e282ab359c1682826f73358cf992fe71775e9eac52f1ae4ceb847fba1ccd0d" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<-EOS.undent
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
