require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.2.0.tgz"
  sha256 "72cd1051b7079fb8eae7b4d37dd05214290954b8c0fa15de98803803944f0020"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c3ec4420fc581b720e9cb108bb4ede4b17703ce8d1757b73de5587598623bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c3ec4420fc581b720e9cb108bb4ede4b17703ce8d1757b73de5587598623bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c3ec4420fc581b720e9cb108bb4ede4b17703ce8d1757b73de5587598623bf"
    sha256 cellar: :any_skip_relocation, ventura:        "9fcc6ec154672fb0c25f8c1eade4f0d65105e864cf6edab6baf1e31b45961178"
    sha256 cellar: :any_skip_relocation, monterey:       "9fcc6ec154672fb0c25f8c1eade4f0d65105e864cf6edab6baf1e31b45961178"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fcc6ec154672fb0c25f8c1eade4f0d65105e864cf6edab6baf1e31b45961178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c3ec4420fc581b720e9cb108bb4ede4b17703ce8d1757b73de5587598623bf"
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
