class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.22.0.tgz"
  sha256 "3e402a3d9d954f893ffc7abceb385e136d4ba6c90578b08d71b6a49a08beb931"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e68291a93816867eb2125b3aa29edcb24fe04530a3d71bf5ac1deaf650a8a905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68291a93816867eb2125b3aa29edcb24fe04530a3d71bf5ac1deaf650a8a905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e68291a93816867eb2125b3aa29edcb24fe04530a3d71bf5ac1deaf650a8a905"
    sha256 cellar: :any_skip_relocation, sonoma:        "c398f1c901d6d2a0ef342f6105ba1203814a449bb0d5d8502ca32053dd07b58d"
    sha256 cellar: :any_skip_relocation, ventura:       "c398f1c901d6d2a0ef342f6105ba1203814a449bb0d5d8502ca32053dd07b58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a38c761ce517a732eb38d618223a5521ee79f8f29b3a83fc03c829960c4c385"
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
