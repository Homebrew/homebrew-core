class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.6.5.tar.gz"
  sha256 "c7d4633d443d1fa2ea5a9d5efcad784bba123c6a6d94da3b2330b51be94bcbf7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8950a5df533a41b0af6770813b6340ed791b66963a50c15a2cac14820c6338d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21cec8cc8e8d9e5821764a11767b8129314b26c31ee112f7c523064be0b9d5be"
    sha256 cellar: :any_skip_relocation, monterey:       "e1f3bd9889a077f89759b7c7702233a3a911e87d0a2b7fee7c9cf41adecbcbcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0853bde45db88939a192104b7a9ab63e22ec18a458c6e2af00e31b141e6ebd5e"
    sha256 cellar: :any_skip_relocation, catalina:       "24a4549f15347d1f1e9c0ecd4e7cc027deb9d0152aaa2fc446fd13db2cadbde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "428e5d8fffa3a0be162be2c9e42894e698eee01130c183821c9042b35898930c"
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
