class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.25.0.tar.gz"
  sha256 "2e93971896a8a6381b60dc31c4b83a9e111b27c578031312e82f2ae381c80a70"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34cbe4c1340069793f377d217716f088d361bb2cc1be3897ed84024fb6b0b558"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90af8732f86c1cf7112dbed47762f0ac249cedc16a75865613f1f0e1293f9b96"
    sha256 cellar: :any_skip_relocation, monterey:       "a19779e70bedcd08fe8c3e3f4d2a5c2d5464183f261b1bd6a5383bfc3aef2832"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe19f2a3dd96521c690097fbf8b74a8e2dc321feed25d6894b2ec07bb6b91f3b"
    sha256 cellar: :any_skip_relocation, catalina:       "a1216c022c08b235b4dbcf43f82f071779160ba963059c2feeee07394e8e5ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34164b5e9dbfbd4a9fb772b45bacc375a21d992488c9d7ab9f72636cab41f386"
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
