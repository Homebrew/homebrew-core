require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.15.1.tgz"
  sha256 "73568ba4f6ab24729d3715e04000e0af75319e2f656f031680ad35266fe5fc9c"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f4cb35c2b27db8a5fd1c8e66c23ffefc8865fb8caf89b0e67e7d426e4bb1f1c" => :catalina
    sha256 "aef654fc5a6e97774395a89b294a3b25793d1c86b33efd16a05c21f024085e02" => :mojave
    sha256 "5009bb2bd99b818eef254d0abdc5bb6514e6c7868d84f56a457d75c5cd011cf3" => :high_sierra
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
