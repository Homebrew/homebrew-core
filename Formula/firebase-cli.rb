require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.1.2.tgz"
  sha256 "e9b73e2ef53eb5bea7e706605058ff15e82ac25765155470f4fe200bd3b4556e"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eb9ed766a1488243821233bd91303ed4632f8b776ae5eddc3589e88ed032ee05" => :big_sur
    sha256 "ebbf33e437b8813653e1ea76dc44773fd5a163ba788f8fcba78b643f57f7c754" => :catalina
    sha256 "532190cb366d485a86f4ffeb583ea3322fb1c9c95ac5e33a6d971ff8826bb22e" => :mojave
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
