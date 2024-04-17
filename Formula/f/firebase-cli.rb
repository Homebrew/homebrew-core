require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.7.2.tgz"
  sha256 "cd4b628b5f7fed21fb2a6990a06d9df448ee6f35d274edc2960506f121f6a986"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9166b1e1ca61bd12200cf9009e7998061bbccf2891fd28e4e0678b990a0ddc02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9166b1e1ca61bd12200cf9009e7998061bbccf2891fd28e4e0678b990a0ddc02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9166b1e1ca61bd12200cf9009e7998061bbccf2891fd28e4e0678b990a0ddc02"
    sha256 cellar: :any_skip_relocation, sonoma:         "27a4befb083e18f84cfbb0b1fff9ed06128432d096d4ab5e9be356ba72a51134"
    sha256 cellar: :any_skip_relocation, ventura:        "27a4befb083e18f84cfbb0b1fff9ed06128432d096d4ab5e9be356ba72a51134"
    sha256 cellar: :any_skip_relocation, monterey:       "27a4befb083e18f84cfbb0b1fff9ed06128432d096d4ab5e9be356ba72a51134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eef4ec2efedc1b848101f0c0f53d966b71a8bb041ca59e93d0ae2c7b088a631"
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
