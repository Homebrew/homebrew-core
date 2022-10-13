class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.2.0.tar.gz"
  sha256 "b79493b9b8bb9a51376ce4c8d3828756cb33ee61c655a64f68e0be161456e71e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "816912ccbfa72b1acfc3693732392f2abe5da9ed2ae33f1def2d016a393d285b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c83ea06e0249f2d15a2993c2dd5d40c5584ff14021d5939dcb2984e2f61f218d"
    sha256 cellar: :any_skip_relocation, monterey:       "d53743f80382f048ad804a127a91a7cb2818d4a6fcd596acdfa32ad07c907188"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9a7c8f1351c1771e7bf432f2bba77bee152ecf51a008f410f8e5f8f043df64f"
    sha256 cellar: :any_skip_relocation, catalina:       "454e4b675a51bd645f449b11cb8b3851080a2ec3ae36f6700e759a63e8abb504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af12cceb138803607d95fe96ffb397262692c0cc8efcbc8673c4b53a422571bd"
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
