require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.13.0.tgz"
  sha256 "500710a8241227619d52f8aae5c27dffe5edb8034b187bcee3b1f9542e5b072b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce4e1b1a83e873d2cad96fe874ea557392d640d204c6ae94b7f1148101a996fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce4e1b1a83e873d2cad96fe874ea557392d640d204c6ae94b7f1148101a996fd"
    sha256 cellar: :any_skip_relocation, monterey:       "7093684bdd581ac471340a52f5cbceb59cef02813d678ea594c693030591b8ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "7093684bdd581ac471340a52f5cbceb59cef02813d678ea594c693030591b8ba"
    sha256 cellar: :any_skip_relocation, catalina:       "7093684bdd581ac471340a52f5cbceb59cef02813d678ea594c693030591b8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce4e1b1a83e873d2cad96fe874ea557392d640d204c6ae94b7f1148101a996fd"
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
