require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.0.1.tgz"
  sha256 "13d1013e976a1004409739a4aa3e029c7b1e4763ec84e6c3a8a4f905cf35257f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbc805dc16ea5cecf0caff63706769aeef9a05b39d9f6af2aa0923bb60376cd3" => :high_sierra
    sha256 "95688c6c8d304076f5022b11e01c5436d154f6a6a0625006db26cffddc111467" => :sierra
    sha256 "76c61c018373b9cc74beaabc10560532ec48281eeceed7311a6f625c1e909076" => :el_capitan
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
