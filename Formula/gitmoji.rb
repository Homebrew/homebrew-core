require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.6.1.tgz"
  sha256 "48ae4d54b76b3356535694858bfc614eba068ef4204443907d0c9b203d6d60de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "801ef556b4cc98f98740d8c59ad605650f6b87b923c8efbe2bc99b1d4faa7551"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ffd087aa3abd52c681234cccd483475c55c7873eddeb535b6f362ff4a8f7f8f"
    sha256 cellar: :any_skip_relocation, catalina:      "8ffd087aa3abd52c681234cccd483475c55c7873eddeb535b6f362ff4a8f7f8f"
    sha256 cellar: :any_skip_relocation, mojave:        "8ffd087aa3abd52c681234cccd483475c55c7873eddeb535b6f362ff4a8f7f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801ef556b4cc98f98740d8c59ad605650f6b87b923c8efbe2bc99b1d4faa7551"
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
