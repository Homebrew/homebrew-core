require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.12.1.tgz"
  sha256 "cb46cbd48137c1ba02851bdf9690c37889ba896433d6dfb6ecd9af643c484158"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "9987aebaada519de0203ba9702058c4fcab15014d08bbd5eba216b176b6d6dd7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c1b084be5c7718b9f26988bb7ebb1efdf078b882623b06d8ff35eda0e22a87d"
    sha256 cellar: :any_skip_relocation, catalina:      "3c1b084be5c7718b9f26988bb7ebb1efdf078b882623b06d8ff35eda0e22a87d"
    sha256 cellar: :any_skip_relocation, mojave:        "3c1b084be5c7718b9f26988bb7ebb1efdf078b882623b06d8ff35eda0e22a87d"
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
