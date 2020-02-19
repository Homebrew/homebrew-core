require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.13.1.tgz"
  sha256 "3900f085296e0c3645980b4326f5f340712f7d99fdaa1991a1bc62f3351f33d0"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0962fa82886567c5fcd895350167ef9f6a0f97dc6493d0239c921f49c41358c6" => :catalina
    sha256 "5b7bbb376a8d9e2de52ba324f2d066eee714a1c58f23b852937ee05eff171b07" => :mojave
    sha256 "de3a4d21ebe9bf06e9cb87a9dff9ac024a7c52fe8e120c59ed73ada53bb1bfd3" => :high_sierra
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
