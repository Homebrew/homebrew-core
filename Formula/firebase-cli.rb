require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.17.5.tgz"
  sha256 "ed77a1dbe484966fa8475b071c96ebfd0a461d1a1a990dc014239aaa5562e87f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "915633b7e01de283d7483c98fc9398ee8cfc2fb70f41874ae4b55bfd408281ad" => :high_sierra
    sha256 "c49ca7b530edd111d6240a74e271dff2a65add40befa01de54ea89f7f39ad1ed" => :sierra
    sha256 "191b342e7ad3b06c7fdee099ccf83b3ad4686eb8f353e1a5ba87060f45eded05" => :el_capitan
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
