class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.13.1.tar.gz"
  sha256 "c4f822c6f58e617517d475a237f4b178a907a17b1862eaca548192d2d64c3426"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd33038fd3631acca290cc816c988171a1ff9b6b1e73e2758621d31b7d557fde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9107e5ee3e4db0973685231708d1037b148a7bd669af28194a3c8705996546e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5bd4bb894c1be3007f8b88ab97b21a0f10b5d4c231ce23a614d6c7cbfc94dc5"
    sha256 cellar: :any_skip_relocation, ventura:        "58e426e98d60d7a17f5e39e36252395c9050a26bf8db3d9baa3b7ad8d35aa13a"
    sha256 cellar: :any_skip_relocation, monterey:       "a73ef9ad42093bacd05027c3736ce9a61fb16395ac974658ffadda761346ecbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "29e47156bca00b88100a4d0bac71eadd65bf899489862ec55dcc3321a8e7982e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe22efbcfe78f15abd7c9e17aed6b8f42e094895e42ab0edd8a735d2362c01b"
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
