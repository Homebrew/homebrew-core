class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.32.2.tar.gz"
  sha256 "e0b506f14a303e518df190b9397277078c17b0dd287a82730707819a1117372b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "042b8a936e7921ea183b430761f0f1897da9f0baf77be5bf6b3f754dba6e5ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2130a3ea8a87a7285aa3f5fcf0690bab1ea7757daa2504da3dccd121e7b068f"
    sha256 cellar: :any_skip_relocation, monterey:       "482b7acb7eec5d98e75c95c3bbea22a424503c68bb6009d009a93855d18063f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a37baa6c3f36eba927a444392702dd540e8314036f5c280102a65af5ca45ef1"
    sha256 cellar: :any_skip_relocation, catalina:       "f01f7699f53478c8fe97fa116a50885864de62f2efe25b8c457e85f6d4719567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9584c68f42398b95543e5af8da167025ea9c2d813e9313a51b7d4be17d5d5ac"
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
