require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.0.1.tgz"
  sha256 "4451bac0252a9868036387cf859101c677f0d8f7f274fa10d404d60a9518e333"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b85b3e2d9a6679c2f2c4e7df800381a0e21b41a0de4956be4a21341ee2e5006" => :mojave
    sha256 "0965c37b88fd3988a558b6dffc3f768054427cf6a09062bc773855b117cd8733" => :high_sierra
    sha256 "be4e3c9763cbb565e05318eec425b561c9b8771221cd6ca068965b8a6e2835eb" => :sierra
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
