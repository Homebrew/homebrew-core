class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.9.1.tar.gz"
  sha256 "fb7dd806564de87c880c1dda0b77a9e66624ce9e047fde551051c0b5938f15b2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4fc22ae0c2b0a5097b67a036d2e97fa025e4b0083f858c2f416396dd03cbe65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88bf1cdb9f88207e643f36f0ca6b90409dfc3ea9c9f1adf5f98b7d5f3118bac6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a255f84e7a61cf6a806b417bf011d4fa8011bdfdb728eea49c894475c1a9d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "15d950e313f84cf895978ffa490443e56d06163ab409ceb4b79a903220d038f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d5509c28667552e8a9174f50833c524317b06314a8dc98682b35da2809fcd36d"
    sha256 cellar: :any_skip_relocation, big_sur:        "65fdea2a5730dccc653dc4a05175d43d81e7bbc738a97a0a1041a560eddb37b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f844dbc3bd8246826fed9b9306a1fe4e518170ab57ffde264ac322243f0df17"
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
