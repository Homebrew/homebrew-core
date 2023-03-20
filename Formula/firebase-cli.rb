require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.24.1.tgz"
  sha256 "984da5368e86c4053d1258d1482386f6eeb60feda3d3f57718d6fc464d19feb9"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "83dcb439e7f2a806cb25a9140587dc7e9ca23eba74d80cf2bdb2cd1535c4d422"
    sha256                               arm64_monterey: "5ac70ffeffe2b771caf7d7e6b0bb4051e3b69def6eee906700f8a9f68de15df8"
    sha256                               arm64_big_sur:  "e0c087fc34484a00e7ffa296323c6815c04ac8b4e05af31c13ee84b54ee52025"
    sha256 cellar: :any_skip_relocation, ventura:        "f4f010ac41887db92814a7a4e8e88ff8848036a6315f8d9383740451ab966491"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f010ac41887db92814a7a4e8e88ff8848036a6315f8d9383740451ab966491"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4f010ac41887db92814a7a4e8e88ff8848036a6315f8d9383740451ab966491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afca00073a9bdd9923e094c587f3048eaa298ef94f0c260c2538cf191a4e8f96"
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
