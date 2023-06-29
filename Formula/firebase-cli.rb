require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.1.tgz"
  sha256 "4cae8b5b5843cf61ae80f5b4afb95d907a693ae8bbab44c73b89b95576ed623f"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "890b092d831b94b8e60812da25621b73211d0b3941a824098835242995a8a1ba"
    sha256                               arm64_monterey: "d0679521016564f8b74195f8533256051117408c2094989d7ca1785f8ccc7001"
    sha256                               arm64_big_sur:  "acf9660de7ac25a6bdca4acbabdd3390d23d0390d1ee5bf0763820aff3dee010"
    sha256 cellar: :any_skip_relocation, ventura:        "4978666c96bc9cc20fea49ab82e5864e1fa7d602429b7c192dc9eff582fb042e"
    sha256 cellar: :any_skip_relocation, monterey:       "4978666c96bc9cc20fea49ab82e5864e1fa7d602429b7c192dc9eff582fb042e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4978666c96bc9cc20fea49ab82e5864e1fa7d602429b7c192dc9eff582fb042e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a4f0bcb60222c61840f0442b268790bcf976b0b950b452c88e20fa93085c4d"
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
