class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.3.1.tar.gz"
  sha256 "23ef5c4d29954ae67929aec4c275e14d1007a9af7267c0f766fa5fde6e03ff40"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cfa774523f5f9699fb6b98277c187f37c48bd6c074f2c08e3ab317e20273291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e9c5df3f43c2891fdb163815c389bc57ba8df88d62e1d85846f322789c06b95"
    sha256 cellar: :any_skip_relocation, monterey:       "52feaa3dd0f865088be862ebb1bf08a917e4480516c45f326bc7060aee1faf9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84aee2e1832bdd9febd13e891adf22766265710e36e14d13097537909a19a58"
    sha256 cellar: :any_skip_relocation, catalina:       "4ab2c03efacb49c6bd8545ec4d7f902b41732b728bf903c1fea45e8c9c07c504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a13277562de33a56d887c5c65c080952d8125e22ec920563ed98dc095ea34d"
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
