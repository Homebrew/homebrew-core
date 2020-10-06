require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.12.0.tgz"
  sha256 "de8e3a5e835105895a454b349f4c73ee80213f5e670ca662c081ff4742cf6da5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "754872ca8acb7bcaf12c2a3283ef3f13c8b48abd49e794d3747fd9e0c20deb3b" => :catalina
    sha256 "412d8b6eacb7c079735aebbf1430ee03cd9fb34bf5292037996608e1f9bb0321" => :mojave
    sha256 "45430c3f0dbb786fe50421f5efbd6eb1af0285eb6419f5ec79ed4191a045e226" => :high_sierra
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
