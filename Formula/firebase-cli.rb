require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.18.5.tgz"
  sha256 "def0a2cba955204a8e6e302e17f2e839d79774b8278bac69583fe8054f69cf88"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf47338b513727463ec7f6742c14e071747cf60aed3501385cd5e2107e055e18" => :high_sierra
    sha256 "1fe484a81bc7dc568e4f8fa7038a37d549beedf191e4124ed749b8def98f73d1" => :sierra
    sha256 "e900fc7106623d90aa084c275bb30cbf11fad6912356b066325ca2eca8c9d368" => :el_capitan
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
