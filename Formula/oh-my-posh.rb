class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.5.0.tar.gz"
  sha256 "cff524b50fe3e5801e5a756263b8077c92fe9863b5fb79890cd2901add21710f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "909068dbd066dee6eaeeb65f25a5e6218586e00539702749157890597e402a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48a876206ae1f9ab10d8972fbd5e74a1e66c043bbf2c71a81c8edfa57435295c"
    sha256 cellar: :any_skip_relocation, monterey:       "4c15ca4c8f88292f3e12832aa629d3690d08ac00982bbfe63b4075c6faa467c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7130b1b6c5de9016f8a8e418a9483ccfc81175f9bc8b3617e625df795d270f40"
    sha256 cellar: :any_skip_relocation, catalina:       "ee6daea2bd711805884cb0592f61ad5c603f875931e92c7d8b6287840b8e33e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f75f9299b1db8cf8392d83821b3c6335662a47a2d7e4a2ddb570374d51812c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
