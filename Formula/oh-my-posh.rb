class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.20.1.tar.gz"
  sha256 "479b7e9d220786917c076df3ec994bfeff58bbe5b3da2f12798656e39ec295fd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b7551989cd41a824616c9e038db80b5ff01bd610739f22e6cf8f1e108858e22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8700cab344ef9a0f276a3ae7d5bbf1af6d6b55761d3b6b2242acb57cccb90f06"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e7358523527b2e3c1639e717285f1d7091693e0023846a59874d339a3676bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b173c0e4cdc97561d3bc62dcb22ba00c29e4d0f3ecfddc1c31c67c2bda8bf7d7"
    sha256 cellar: :any_skip_relocation, catalina:       "cd5d12903f0e4b103d9d93b6a806baf6cdbed35a8ad292a3c97fb8ffbca9f290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f29c97c7ec186410e00026f636e36701735c030660b665d2c9e247df5d5d3a7"
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
