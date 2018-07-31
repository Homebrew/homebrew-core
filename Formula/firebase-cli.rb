require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-4.0.1.tgz"
  sha256 "13d1013e976a1004409739a4aa3e029c7b1e4763ec84e6c3a8a4f905cf35257f"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bac409c9a0a63ac191060742fb93292d1a42039618223910037b41a2f5632b08" => :high_sierra
    sha256 "9392b7530bd17592403cddd49411141fa9e3604695181ea8e7f059e88eeb3c87" => :sierra
    sha256 "dd6d6e4a752c8c6611607764182f1f17f4e6289e976160ab3a41b749b324dac3" => :el_capitan
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
