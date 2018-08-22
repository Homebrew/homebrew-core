require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.2.0.tgz"
  sha256 "7be1ef39d70ca89772fe4362bf36d6afe4bf7f19d69d5629cc39d6acbc7b9593"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6786fa7b598d1493bb8805c3e46a1eac99e5660756c79a06c859434c97c56eee" => :high_sierra
    sha256 "cbb4168b8507d3ffe312bdd4bfb12783396cfd352bfdb3e668e11067604401cb" => :sierra
    sha256 "d5f7356dc532fa33e8548afc30e2eb717000543539b39719353c14bb4da64935" => :el_capitan
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
