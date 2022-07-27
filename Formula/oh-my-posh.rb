class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.7.tar.gz"
  sha256 "1f50fa13fe7627339cb4bfec2cb4ed778c6b2b5f99dde06ae8ec4bb592499cc0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a712144639cd85f2e65e9c3cf79c0573b68f52663b509724f5f83bc31e81a4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c98bf6ddfbb0109c4533cf06462f7572a5e947c5a9922ebd49a51591a22a4b1"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf0b9576245c8407e1e1610cbcbf72257aeef2fa2b5444f1ca9c34ba6e304bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b195d9a6995a8076dd7d4ad44d8fc322bb43575a5b4db522af6944f77fe637b8"
    sha256 cellar: :any_skip_relocation, catalina:       "dd84fd95b3c5f3cb3a858550fe793ad684b6333df7dc07174596765a12f95680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d09c82eb1de78b8f0d8b3dd4a2a8d3effc7cd3fdd094fc94553df2d8689ca2"
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
