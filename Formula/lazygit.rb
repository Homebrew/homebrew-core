class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.38.2.tar.gz"
  sha256 "2e727db952022c0518443d18c9b8a97a882970b93c5ab198ff33bb8ed2166c2f"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40dafb9962149161d30f6bbcd8dbdc4e4e893354416c0711e978dbc636011963"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40dafb9962149161d30f6bbcd8dbdc4e4e893354416c0711e978dbc636011963"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40dafb9962149161d30f6bbcd8dbdc4e4e893354416c0711e978dbc636011963"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd6cea246579a68682f8c9e735024547589283f7a00e8247c222f3970282874"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd6cea246579a68682f8c9e735024547589283f7a00e8247c222f3970282874"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd6cea246579a68682f8c9e735024547589283f7a00e8247c222f3970282874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ce9273c0493b10bd1839ee45cf2ab646043f5dde577472bcdb967c3ef5e3175"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' to do certain tasks
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "2" # cherry pick commit
    ENV["LAZYGIT_DAEMON_INSTRUCTION"] = "{\"Todo\":\"pick 401a0c3\"}"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "pick 401a0c3", (testpath/"git-rebase-todo").read
  end
end
