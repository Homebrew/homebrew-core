class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.1.0.tar.gz"
  sha256 "eb1b17c6efe4232ad263c43470e5c82f2c27b5e9e0a84cb7027dcea9a2d446ff"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a49268e5987fe884ca727c06553c2fa5c626f2b9c4fd9f3d74b88c9f021128f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "687a173cc8ce8871b22c4139fdf487400cc17160b6275c9836d327a971f649f2"
    sha256 cellar: :any_skip_relocation, monterey:       "7ebf402bc6a9830afa1a132bd530a24e02983c1d9a0f7e1381922c9636d1453c"
    sha256 cellar: :any_skip_relocation, big_sur:        "98b53cb545ea48ca436e1a5c889a30eb04ef71929e9f4168b506f79c9fe79474"
    sha256 cellar: :any_skip_relocation, catalina:       "1a32763b6e6f97dc5fcb08e5e0a9c024a4f40e20a631da0a7a4f5c7dfc862ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff299b52f445483855453ca540317bcf1ac6fda3f782e89388162045b61618f"
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
