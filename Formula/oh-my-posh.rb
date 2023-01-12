class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.1.0.tar.gz"
  sha256 "0da13d03ad34efc2816e5835f8052630f27c8d681b933c9a7133f4425da7ecc9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efb8f0c7b1ea878ae1682e874b862ff2153ea3792387bf1caf5cdc34f20b31a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5488ee12e33cf57454ff1361bfb1e537f001a8b4f13f887233e97c0af7230bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7658b5a3114713bd2e70164bd99dfc083a340bf6085934309919ad6a09a8eebf"
    sha256 cellar: :any_skip_relocation, ventura:        "c24348f9e65a93e2889594f45417b3937abfd7aa097029c7f6961aaca2d5f49e"
    sha256 cellar: :any_skip_relocation, monterey:       "a43b81df4c85711891650257583ee9a3b408e2fff3a87bc0e98ccdaf41a33c91"
    sha256 cellar: :any_skip_relocation, big_sur:        "50a2c308055939704e6c011c0b08d155c8d2eca1eb638145284c38ad2d98fba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbfc982d0fab7f989a0f572ce86cb43c17aa2ca253a00bf5441bbc7eeecae997"
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
