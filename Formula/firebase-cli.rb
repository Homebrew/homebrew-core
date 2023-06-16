require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.0.tgz"
  sha256 "3a1d2b12e0c86e5d5bb24ace12a9b95501ccb650889060ae6655dddcef5891da"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d9a9271f6223b139cc8045db122b5746a542338efb3d76216831e86d27e962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3d9a9271f6223b139cc8045db122b5746a542338efb3d76216831e86d27e962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3d9a9271f6223b139cc8045db122b5746a542338efb3d76216831e86d27e962"
    sha256 cellar: :any_skip_relocation, ventura:        "ddb7821cf2ea8cb5af405eac27d90293980d30ac24bdafdcfd5cde58bdde4270"
    sha256 cellar: :any_skip_relocation, monterey:       "ddb7821cf2ea8cb5af405eac27d90293980d30ac24bdafdcfd5cde58bdde4270"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddb7821cf2ea8cb5af405eac27d90293980d30ac24bdafdcfd5cde58bdde4270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "503138f10247f9f5e8db767dad5947d207d9d2dff55c018ce0b445923c941a82"
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
