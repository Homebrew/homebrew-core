require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.18.5.tgz"
  sha256 "def0a2cba955204a8e6e302e17f2e839d79774b8278bac69583fe8054f69cf88"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a81d011013251b724ff4d3c2aeddf39039531235733fba9c2bbd74fa0b4c4c36" => :high_sierra
    sha256 "86b250eb022a5bd9315bf1f8d830560d20a34ae105465491c80ac91c142d188a" => :sierra
    sha256 "1d3bf8d9b8c22764b4a34c692eaeee39bded3500a23019a4720867600a34f830" => :el_capitan
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
