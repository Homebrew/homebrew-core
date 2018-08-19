require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.1.2.tgz"
  sha256 "fabaedf9e7f12f4d90ea7d1331ca8689ca586be730906688c0f72cf8924ffdd4"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a38cf0fd8b2809b17b9477c4c27d5a6ca17e0e8cfd077f93f07e714ef60c78bf" => :high_sierra
    sha256 "761f3e3c402b1ff773a10f50aaa3f523100f0ca7334953aa461a2843d4fd6062" => :sierra
    sha256 "6f6a94e9f8c89649b15f54d5025402ba8661e444257d2a6755743fdce24f8dbf" => :el_capitan
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
