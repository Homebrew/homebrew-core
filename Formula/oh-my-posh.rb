class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.36.7.tar.gz"
  sha256 "8a21411aaeeeadeb23768f14fb108b3126f459b3a1106a74858dcd2cf77e455d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d396d26184b6116e31becd9369e85b155ce770197e0d0a16db5f588c996e0d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "799584381cefff933069267792ab03a489260c3bfd5477ad351d6fb359258075"
    sha256 cellar: :any_skip_relocation, monterey:       "a84c74abb568d859654a6f6d4c25ede2510b9cbd564cebaafe5b18c501c559bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "658686dede56a0527e745b6b195879226bc3452b8d610ce550e4ff2babc471cb"
    sha256 cellar: :any_skip_relocation, catalina:       "1d25e00fb38692c32d75035d712c5291e3b833de86ca3b92fd63911793de0dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4baf2ee70aa02046d18aa4fe15f17fb3e880b3f0be29e040eec84f603828ff"
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
