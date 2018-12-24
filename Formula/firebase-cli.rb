require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-6.2.2.tgz"
  sha256 "3fc32719ffaf93d75f5ae71f909bc53a05efebdee40f608b92501b03d5a9e72e"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d50d9b2d96e0776986916260b9f7c72e6bf55d55c29cf6bab0f619d4f755230" => :mojave
    sha256 "7c4d4c74366bd95bc0a375ef32c22d1b46c0cbec8e406d37d26cfdfc5b2eb108" => :high_sierra
    sha256 "395c04e22183cebe694083485213c0ca5584ea64479bf0980a5968a105441967" => :sierra
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
