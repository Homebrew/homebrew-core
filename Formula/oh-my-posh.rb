class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.5.2.tar.gz"
  sha256 "bbb7d10f7485237b937a38c216662beddfa02a6adb75f56f75ed7a52157da635"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9e540651badb3f5918aaf176f1e6f93f13ac05aa6ce121eedb2565dfe5ac485"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f250bdc19b424226203da4c8b39ca110eb982547c08d86405bc9ef42413bcc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "840ffde3ce6fd3f02a3297346f15000f208c09ac0ee7c205a4d53c37ee476ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "ea6440e9cfa31d8c702a8f3c964e339b437024faeb3f1bb41d1e06fa1748c120"
    sha256 cellar: :any_skip_relocation, monterey:       "2d92ee83c16bb64fe87893ea1b6af1c2e22cd6e1540eccc19f5d7c0ec6166e1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c4c99980026bedf1f297ac9eea83a7a216eff0e15329c42f523a43dc1f44966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4e8a6d492bdcad5e312220fcf03e0d6397941d774e0f84481f6b9e501ce10a"
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
