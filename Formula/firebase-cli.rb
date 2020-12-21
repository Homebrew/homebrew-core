require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.1.0.tgz"
  sha256 "55a19dbc04fd94c67e3c8c3d3286ac5e690dd3b613ab5966fa648a97f8aa517f"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "34164972650e94b084643c4ce496af25ad7486abe894557c205535c8e1d2fed3" => :big_sur
    sha256 "2a162e6de7db4c2486f81da3515a79a303bfec4843ce345a29cdad0da354e789" => :catalina
    sha256 "1f0adbfb2af8ba669615510e7ea805e5afa1adaed41d54592fe92df7c9afc435" => :mojave
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
