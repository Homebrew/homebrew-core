require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.19.3.tgz"
  sha256 "463107d764d46f5ece454b1e4bc7c11a891acec2761d32bcdf9952d0feec3da3"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77579636fab7153e239d92d962d81534ef3acf57de331063d3e8901236c023c0" => :high_sierra
    sha256 "dbc6300d5dd6e066de242808bfc3ca1e9819357bd3fbcf9b337173ed7358b48b" => :sierra
    sha256 "f2cdf02274aacbb48dd8150bdb1841e4e23e7b8e61e86d91768f2278fc1e9dd2" => :el_capitan
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
