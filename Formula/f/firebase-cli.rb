require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.11.2.tgz"
  sha256 "601fa6a5f89a20118fb998e34aacf2ef81da69ce793317acc8c6cc4b8ed85e25"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d9a3d131781f81fa2dfa29b86156414d398adcf80d0d1b83487d05933bd565f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d9a3d131781f81fa2dfa29b86156414d398adcf80d0d1b83487d05933bd565f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d9a3d131781f81fa2dfa29b86156414d398adcf80d0d1b83487d05933bd565f"
    sha256 cellar: :any_skip_relocation, sonoma:         "621a84e4698c2e969f941528448ebaaca1ab2141ac1e730cac74b71d5b3751a0"
    sha256 cellar: :any_skip_relocation, ventura:        "621a84e4698c2e969f941528448ebaaca1ab2141ac1e730cac74b71d5b3751a0"
    sha256 cellar: :any_skip_relocation, monterey:       "621a84e4698c2e969f941528448ebaaca1ab2141ac1e730cac74b71d5b3751a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32bcb9076a5a7017aa11f7f541f7f9a599d4b0afc1510ffe69e0010d692eaab2"
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
