require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.0.1.tgz"
  sha256 "4451bac0252a9868036387cf859101c677f0d8f7f274fa10d404d60a9518e333"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89647efea43cf52b447f2506d24f796e25a706f64c9d18a28267af2513b7ba83" => :mojave
    sha256 "25339b0b2c4f179e550d1a01230cd6a434d77760e43f6dda682e61e59b078f16" => :high_sierra
    sha256 "d48a1786567c007e2267df4107e70644a523fcbcbb096ba3e6ef4873cd3e32b4" => :sierra
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
