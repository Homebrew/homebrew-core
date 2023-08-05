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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1a8f2cf9e1ea6ddbceb5640eb45d17be295387bab697492fad4ad32501cf002"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1a8f2cf9e1ea6ddbceb5640eb45d17be295387bab697492fad4ad32501cf002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1a8f2cf9e1ea6ddbceb5640eb45d17be295387bab697492fad4ad32501cf002"
    sha256 cellar: :any_skip_relocation, ventura:        "6056a5d3649c063450dc206c3cdf62d97e321d136dddacc83e403513740d32a3"
    sha256 cellar: :any_skip_relocation, monterey:       "6056a5d3649c063450dc206c3cdf62d97e321d136dddacc83e403513740d32a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6056a5d3649c063450dc206c3cdf62d97e321d136dddacc83e403513740d32a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8613c15790152098384dd5562a87c28bf76d766505d2b9c13ed3d326fb6311a"
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
