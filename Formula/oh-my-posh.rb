class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.15.0.tar.gz"
  sha256 "ec7577e748e8b027531db68c2b2d756897041fc16711c9d8c62c6cd6c24a0226"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a4308fb33316a88e5d9926b1c412e63a3a8e925a13ef7217070b6e2efa34474"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "316347bc05854b4e8e9f4bbcfc8d0b646533138d008f92c708f81d4401f42d88"
    sha256 cellar: :any_skip_relocation, monterey:       "e05dd6830e91e99ce9497a47a522f29e3599a6ed19ecf20f1940a47c3d601e80"
    sha256 cellar: :any_skip_relocation, big_sur:        "13e3b620c72d524a09fc40db70eed3d4ab736c5320790dfa3d2090b4037b2b09"
    sha256 cellar: :any_skip_relocation, catalina:       "b69554516ce399fbb5278742b0cd6fc8ca25420bbe69bbfabcc78eaf359fd878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "475030baac3f68cbf1b41c1195ff8a79286f83f2eeaf27241d9e355092f37e40"
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
