class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.21.0.tgz"
  sha256 "325f90f9dfb486433c2945b285c7cbe8d13b5fa6c5af0bb306bec8e628131a6d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf4bbe0db7d22ba7080cc5c963271b77e634b660fbd82ada0af8d8cd9bbb8586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf4bbe0db7d22ba7080cc5c963271b77e634b660fbd82ada0af8d8cd9bbb8586"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf4bbe0db7d22ba7080cc5c963271b77e634b660fbd82ada0af8d8cd9bbb8586"
    sha256 cellar: :any_skip_relocation, sonoma:        "62bda31090908590ce0f62cb7a3215bdc35a097bd81aee7d0f628b7835f69ac4"
    sha256 cellar: :any_skip_relocation, ventura:       "62bda31090908590ce0f62cb7a3215bdc35a097bd81aee7d0f628b7835f69ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669606376d8d96f847a05168989a6d51e8cca8cb14678d42f26aea6077aee32b"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
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
