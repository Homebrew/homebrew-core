require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.12.0.tgz"
  sha256 "8e2cdcf8eec838bdfe766eebffb0fca9dad3a92d7be5c7697784e535e323c779"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "1c6ca355dc6b8b54f24bbe02cc02d222e302f27f2b27d2f12680ea1f2dba6af5"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f3ad182090d3525aaf22eaefd31847e7fb20e1abc2cabde734c4be2a69a04dd"
    sha256 cellar: :any_skip_relocation, catalina:      "1f3ad182090d3525aaf22eaefd31847e7fb20e1abc2cabde734c4be2a69a04dd"
    sha256 cellar: :any_skip_relocation, mojave:        "1f3ad182090d3525aaf22eaefd31847e7fb20e1abc2cabde734c4be2a69a04dd"
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
