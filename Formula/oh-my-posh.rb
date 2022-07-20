class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.20.0.tar.gz"
  sha256 "e4e2ed6bf8aa517e9329e55cd660676c4d22e23fc22df3ae98c1635b2ac8a257"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9c9e5ba913f4b5fd034b418ad8d1c64c085ebf7b66fe234b6f1d93d7834fd25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0122e20d7601848d23006948ee587513d0a419bd33fa31a195bb42798767e177"
    sha256 cellar: :any_skip_relocation, monterey:       "308aac8383584a585f63b446135a0bd6ab57cec1d092683f0218e4382db36582"
    sha256 cellar: :any_skip_relocation, big_sur:        "05977d876df1dc1882b72242c0e7897f65bdfbc7f42b0a91517c8a0df02e4b9a"
    sha256 cellar: :any_skip_relocation, catalina:       "ce8ecca65403e4b7d9820dffdaa37467664cb292028c7036f6ce80564c7b3ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bda684cdce3de691f019cdd3941e0eecf058dec6bb36e56cd0b69f509b08381"
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
