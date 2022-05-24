class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.91.0.tar.gz"
  sha256 "011a61d91149b06f4c530634a855cd3a2d4cb1e048e0eeb5476ce01ba9b21690"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e519f0f43367722c589f216a9678b05cd72ef64166eb574d6aa75a4b70251c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53e488d9932859891ab7b1618438b002efae65e3ceee492cb47ad3c092ab5d88"
    sha256 cellar: :any_skip_relocation, monterey:       "dbc6841e4dfce40c1e8318e938e2971664bd62a9e0242a1df82c1dc5c12669c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "199361a1976efb7d6e9a9c61f69f97ad8da3ef660e79c5bc0ceb805ff2506e14"
    sha256 cellar: :any_skip_relocation, catalina:       "5eeddc30b7e413c63bf9dbde6a1bd11a506344e3ff992976c0208a941edae157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54079cc6f26337e54afe2df2fd4074676bfcd868525180834977af4a6780a3d6"
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
