require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.3.1.tgz"
  sha256 "18b8c9491becaa84196e1bb93942456a3d84e531ebea271d5891923c5961b612"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1336bdd8401a40e9f14fbb23e99baf0f8cceb696b2cf2646f6550b9517dce070"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1336bdd8401a40e9f14fbb23e99baf0f8cceb696b2cf2646f6550b9517dce070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1336bdd8401a40e9f14fbb23e99baf0f8cceb696b2cf2646f6550b9517dce070"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcd2df550f9827011204dfb3f4c222206b8658c0c2ed124cdcb0de97ca31a0ef"
    sha256 cellar: :any_skip_relocation, ventura:        "fcd2df550f9827011204dfb3f4c222206b8658c0c2ed124cdcb0de97ca31a0ef"
    sha256 cellar: :any_skip_relocation, monterey:       "fcd2df550f9827011204dfb3f4c222206b8658c0c2ed124cdcb0de97ca31a0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b893638f5409bf1322e4a7e46639730a1d66ef1842bfde6a6a5a4bcd125de835"
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
