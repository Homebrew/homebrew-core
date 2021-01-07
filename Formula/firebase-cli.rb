require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.1.1.tgz"
  sha256 "c76536b0e2d4d0af8867ce6428df04521afbbf0213df87957a68246c32cf77fb"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a8048e0d68620bc6d16b7883afcd9fa78c5cc12580e76d3722603438dd9a5137" => :big_sur
    sha256 "e584a031bf20a4d33840abe92a801a13d5ccfbb94dcde772076dcaf4fb31af04" => :catalina
    sha256 "25ba3b3a9fbe8046fb126cb49e7954a4faebf2ab0e4938866ae7a98f0411596d" => :mojave
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
