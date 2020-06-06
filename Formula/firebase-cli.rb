require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.4.2.tgz"
  sha256 "3c52c51b889ef0c3a8615afaae1d55f6b39034af3ccbb61b805de95b9b2991ab"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7ef356213758f4086dab612c7d28cb7868f8ecec8d98b188b028bed1ac93013" => :catalina
    sha256 "52070538131cd17d28bda793fa0743992ae90ba06e42f23c6e15cc09e4bec60a" => :mojave
    sha256 "e73f0f00c9ada7188b0d11faa439021beb4ce184b310e7b1ac32e59048dba6f2" => :high_sierra
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
