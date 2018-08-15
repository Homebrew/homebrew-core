require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.1.1.tgz"
  sha256 "b31eefe5a189674af517211a54bf63f93a7cddd17b119d1b2a25ac4195d57697"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63237d0629812995085113303a0806357717cd2a446153f9e50d34fcf4173381" => :high_sierra
    sha256 "8d0366e6649774e251260e41882c4e06036a198197018092412d703edc1a34d8" => :sierra
    sha256 "03fad4de8bb00c9607f7b73eaef509b9fbef1dc78336c49bce17a83faec2568f" => :el_capitan
  end

  depends_on "node"

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
