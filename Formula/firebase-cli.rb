require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.9.0.tgz"
  sha256 "544070dbd2955a3613d7f0c5a05cc1088b144ddef2776a893244c3d194871c2b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30cdddec66072042fde772327066b2c6607551d2adc52be7ba696cc116a5cf33" => :catalina
    sha256 "c264985723ddb45ce4081a9618468778d6bbce73dd79952b4f75dbeb35e24125" => :mojave
    sha256 "db12ccc7ac59d5b5a18a0b5fda113f71a4be10501c70c54e9bbad6b12856f6ce" => :high_sierra
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
