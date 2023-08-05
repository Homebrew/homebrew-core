class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.40.0.tar.gz"
  sha256 "6a30a23ea4e9a83916d046655b33d4d59f1fa3b408c4b2f9d1e1160e58c6f76b"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "601473c8398798fa7ef34e18c477896e0c0745ddf107862a6dfaf2c5fa740cae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601473c8398798fa7ef34e18c477896e0c0745ddf107862a6dfaf2c5fa740cae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "601473c8398798fa7ef34e18c477896e0c0745ddf107862a6dfaf2c5fa740cae"
    sha256 cellar: :any_skip_relocation, ventura:        "357efc691ade0075c97f48bd149418a5f674f8c49f69e4b67db0aac1dbb2b1b1"
    sha256 cellar: :any_skip_relocation, monterey:       "357efc691ade0075c97f48bd149418a5f674f8c49f69e4b67db0aac1dbb2b1b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "357efc691ade0075c97f48bd149418a5f674f8c49f69e4b67db0aac1dbb2b1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "066d57dcf3ae516b9de5046355069ce30a7cbbb8a71ce8d2a34f3b8ffabab2e4"
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
