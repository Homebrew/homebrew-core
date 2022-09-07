class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.0.0.tar.gz"
  sha256 "b8a6c00ff01ea443b509d742547530cae7c3e7d53d99a77f7b7284b200c86e30"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be0711b3e76030b0e6e5693bcd9ce053a563ceb451ab48520d53796a062adf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a80300e4a79a7d044c6d20631d4bbc10ff92ca224b0c0c3e1fc9f6a2d6e883f7"
    sha256 cellar: :any_skip_relocation, monterey:       "62138d44bf9c6522ca000de1b1627cf53043ae06d2d9eff40b5163d574a8c074"
    sha256 cellar: :any_skip_relocation, big_sur:        "b98558dae2dc04f787c5bf75fb253240806c02d151485e4a3068136c3812e394"
    sha256 cellar: :any_skip_relocation, catalina:       "7e04ffd32c802eb245890a64d0088351f609127ff6efd74e56f3e2df802ad502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c21b61a32579638a14d08b20301abc8d3b8a61ea7b84301d625a2f487fff319f"
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
