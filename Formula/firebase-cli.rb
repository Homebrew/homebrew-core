require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.6.1.tgz"
  sha256 "a6f98604bf03c671c4372a12eded0d10482164f594a47b79e54310c6a02f0752"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "28d21f8585f99ff77b3af7f7defcccd0a9b24e652a10156fd958b8234b07629a"
    sha256 cellar: :any_skip_relocation, big_sur:       "495559fc5331a55daa0e8cc82bef763d68f6176b3f90b48d483cfd5e1120b8ce"
    sha256 cellar: :any_skip_relocation, catalina:      "cc1412e2205a79a23b1e22d4732cf4a1d348d64b9feb92c2bfeb861f1333e7f0"
    sha256 cellar: :any_skip_relocation, mojave:        "121dced0312780bfa81ae889fa8f6e328b8e2650a37247146b71ba40b75b569c"
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
