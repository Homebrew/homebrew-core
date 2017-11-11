require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.15.0.tgz"
  sha256 "b03f2e278d0400d47eeeef11b5c4602b5d7576d0abdcafa960a414bacd2d376a"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "98551adc4fe39c8d84902fab922ec4a799ae6df79b572ad65ea158ccaf95d484" => :high_sierra
    sha256 "35620014cec029ddbfd79ce5733c4c22dc48460ea103124e85b86d5c5715be7d" => :sierra
    sha256 "08968bb6b0aa4e1fccccdda2cde813841910f9a690101b2d12e72d2e0d902081" => :el_capitan
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
