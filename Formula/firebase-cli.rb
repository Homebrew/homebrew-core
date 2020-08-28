require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.9.2.tgz"
  sha256 "78e333e86fd94647ad982957464c3033f345e2b8edc5934620cc09629b4a8917"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9fc0c1d3051805b2324c019316d4a387da1cc933bdcb91556da6d816b212873b" => :catalina
    sha256 "7a922ecefd3e3789b33fdcab099ae528a80fd11bdc1cdcd378962672ef87a312" => :mojave
    sha256 "f77d305a49cda9762b9df05c941871f9b2e9475fd1c4d7131cecf4d3df1cd24d" => :high_sierra
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
