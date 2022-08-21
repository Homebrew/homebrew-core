require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-6.1.0.tgz"
  sha256 "4128037744398ba52ae520d2bb61f2094e7a64e715ce0b4c4fac36cd7fca7aab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a5d0a9de873834a9f3a8409b7247792c562c84f714678a3f260d4b88913bdc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a5d0a9de873834a9f3a8409b7247792c562c84f714678a3f260d4b88913bdc0"
    sha256 cellar: :any_skip_relocation, monterey:       "56deda4b4943ee86039b745f284a4ad5f6c5e1e392171b84523dc6cf65917d08"
    sha256 cellar: :any_skip_relocation, big_sur:        "56deda4b4943ee86039b745f284a4ad5f6c5e1e392171b84523dc6cf65917d08"
    sha256 cellar: :any_skip_relocation, catalina:       "56deda4b4943ee86039b745f284a4ad5f6c5e1e392171b84523dc6cf65917d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a5d0a9de873834a9f3a8409b7247792c562c84f714678a3f260d4b88913bdc0"
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
