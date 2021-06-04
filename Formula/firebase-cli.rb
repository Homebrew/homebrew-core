require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.12.1.tgz"
  sha256 "cb46cbd48137c1ba02851bdf9690c37889ba896433d6dfb6ecd9af643c484158"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "fe6f929b4950e9b6010118dd71bd7a34ba27bf221ed98e773e6e7a89b7088082"
    sha256 cellar: :any_skip_relocation, big_sur:       "800ebb5b112934a59922865139eab53db29d748c3012e0dfd33f745a8345ffc5"
    sha256 cellar: :any_skip_relocation, catalina:      "800ebb5b112934a59922865139eab53db29d748c3012e0dfd33f745a8345ffc5"
    sha256 cellar: :any_skip_relocation, mojave:        "800ebb5b112934a59922865139eab53db29d748c3012e0dfd33f745a8345ffc5"
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
