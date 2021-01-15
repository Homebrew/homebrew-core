require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.2.1.tgz"
  sha256 "6e6298ae51418907559c8a4a96d8f64699a94df5421fb84f1c89e9365fa54084"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d2709d1a4eeadf7d81833d9b322dd5c3770c7d258e5bce4b4db762868ec17445" => :big_sur
    sha256 "d64463aafec7bd87c8e8bd60ac3f4038d382ae7506d6e2ff39c75858154b2c40" => :arm64_big_sur
    sha256 "1155228b2bc5f4b086786c27f1499a3b9089e8932f15dfa2061aaa3cc7de1adc" => :catalina
    sha256 "ea211e4ea27932dcdb9de7155ca7196b54a635df40b4232e5982cc1c7bbd545d" => :mojave
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
