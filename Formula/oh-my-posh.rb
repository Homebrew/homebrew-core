class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.9.0.tar.gz"
  sha256 "e5b1d044946d01a5b0a6ecd630e8724fe27a84ee80f668ba74ceaba71266c0ba"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401765aab96e0e0eb14961421f78ae82b1f20bf68ec75bfbab531c2415efdb89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49840e2455ea0ff937bb6225f155336d96be5ce4224a09fe4d7f6edc321308e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5604e5e0e891faa70d848352a336b8b0804c4fee6a9361bac66fa2f9c0e71c36"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fed05542dcb0a9a1615097ecd910d583eb3fff764f99546f6d56efd6c745f83"
    sha256 cellar: :any_skip_relocation, catalina:       "414921c6d1819801c1453facd33d613878ab3adb06ffd51e2407bce5b33cb905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db8dbb8856e57bbf7462c83ca8b963d8c843e7856eba1bf69f592bd7d4fa7179"
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
