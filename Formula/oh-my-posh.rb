class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.90.2.tar.gz"
  sha256 "338375891e760105aaee9c14929d9a1a71a4fd694a43d5f063848d07e856486f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b70d1147aa27c0f6309c5843220895e9cfa426249a5d0f5e96081bb26a9d8b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d1850d1e24e3722b96860628174b5d2bf5053056ca1e3ec672598480a7eb8c"
    sha256 cellar: :any_skip_relocation, monterey:       "b322e475cb1658c5c0e48b700ef6afa40b6abed451fc83170e670df395efaeb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea87693f70b89ad4c8e1b4304b266eea3f805204699a1b1d25501f717830f100"
    sha256 cellar: :any_skip_relocation, catalina:       "1ef41785aeee12a480ef43889b0636c6903dcc5d757e56eff8445d7581fff891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e5c6f26457f14032fbeccffa2a9abf3610496f8b9025c91da86d666b1c095c"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
