require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.2.1.tgz"
  sha256 "c916360e42182aa15702e2efa115b75921b57b30cf6537f9be3918f5cd9cf844"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "155511ad01af3a5fa88eb112d15209d7a27be06b8cb69a5d90a9b131ad120056"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "155511ad01af3a5fa88eb112d15209d7a27be06b8cb69a5d90a9b131ad120056"
    sha256 cellar: :any_skip_relocation, monterey:       "0b0afdbb40c9b45c6ffdff476691d183de9f0bd8f6fc51f5437688fef41dc18c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b0afdbb40c9b45c6ffdff476691d183de9f0bd8f6fc51f5437688fef41dc18c"
    sha256 cellar: :any_skip_relocation, catalina:       "0b0afdbb40c9b45c6ffdff476691d183de9f0bd8f6fc51f5437688fef41dc18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155511ad01af3a5fa88eb112d15209d7a27be06b8cb69a5d90a9b131ad120056"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
