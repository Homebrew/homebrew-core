class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.92.1.tar.gz"
  sha256 "aecaeb5f1548a2059299212c6c87c3d895ab6e888d6ef45be2c834f82859aaa4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499fa399f0eaa5eadf987ca38284ab898ca81d4b91f070004965261df01ba2bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "451318b579563053c49efd0e652207496714cfaa7eac2fe6a9bf137dcb50fc5d"
    sha256 cellar: :any_skip_relocation, monterey:       "fa0571fc00698916c163941de4482fbb6a97b793b583e46c6ff50a23a5015074"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe0e049933b67ef1c3d33ac7f04d07e184db4aa5a91a6ade33bec6239ec7119"
    sha256 cellar: :any_skip_relocation, catalina:       "a276a1f3105fce4d7214d5258e1e08bb8a3211203e16a8bd53fe5106cb9e3d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08fce4f0c821cb5a279dfd6f4c5889dd7b65910ffb4f068fb6f41043c5ed0a29"
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
