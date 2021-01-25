require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.2.2.tgz"
  sha256 "a3ee99ca71e92742133d729dab02f6189e3e8d8f3610b1de5981c9a68cfd5db0"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "4e85db8763929ab219801286bbfcda55afc45798137587c3f70de4457053444b" => :big_sur
    sha256 "d92445ca66cfb7bf5afe6965016c631296a9a40d2e6d1ad587a9c29071902d95" => :arm64_big_sur
    sha256 "bac6351e975ccb9f583db7d98ef9211e179cc91d9f78a1cf7c5d221fad68926d" => :catalina
    sha256 "351dee62026d416a70dddc5800174afbab9014040dd643a625e34ae4f0cdb402" => :mojave
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
