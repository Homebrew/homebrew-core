require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.13.1.tgz"
  sha256 "0753bcf566e0d084404f9861bc70f21d5164e09eb03e6e8ca7e442337409585d"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "8e94721d174ab0c68a532d6b2098cea730e7452b6364eddc9fbbe7fc27c4f656" => :high_sierra
    sha256 "f994a95f3114308112931e718462b3a3ba106e5aecabfc512455cb5c292e3bb7" => :sierra
    sha256 "be023ce3a67106584980c049500e5f295da155e1d880a19c76797a8d638bb8de" => :el_capitan
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
