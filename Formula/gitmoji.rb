require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-7.0.1.tgz"
  sha256 "6021085193dfb48ac4b15a467534bb924af0a46f40edc2bf03a926cf01ad4992"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16a3aa3d38b84125df6e3c330a1e77169c6867c1c1370638f3f3b3fa76003ce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16a3aa3d38b84125df6e3c330a1e77169c6867c1c1370638f3f3b3fa76003ce5"
    sha256 cellar: :any_skip_relocation, monterey:       "efe21de97ea084da110922771accd89f7af2a7e945290f10e70dc8ba205a07b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "efe21de97ea084da110922771accd89f7af2a7e945290f10e70dc8ba205a07b7"
    sha256 cellar: :any_skip_relocation, catalina:       "efe21de97ea084da110922771accd89f7af2a7e945290f10e70dc8ba205a07b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a3aa3d38b84125df6e3c330a1e77169c6867c1c1370638f3f3b3fa76003ce5"
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
