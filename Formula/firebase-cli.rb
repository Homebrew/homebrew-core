require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.10.0.tgz"
  sha256 "10ec69b5d47d5bdf95f5e2258d9cb944e1d76c13b32aef63b6485f83e89ef47f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd270cd930992d77be077cef0a02c5dbb676f64d2a45e9d10834a76b0af641d8" => :catalina
    sha256 "67baa21abdfd785b0024df7fb5051fad40a26016abb93e78b06fa704e661b6b0" => :mojave
    sha256 "973116803d42f7ab827bbd2a30fbfd2a5bdf3fe8d2a5f851206a81847fb91372" => :high_sierra
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
