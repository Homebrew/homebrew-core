class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.6.tar.gz"
  sha256 "58eae879a3442620d25418b3d8ddce0bc6929c551c11cae8a25f692d8021c2bd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4453df3bc5217a365c1a64d8a9ce0ae512935b70faf03b57c13044a64cd6e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3dec8da015fbe032d253991c4517856d3a9a242da13ba30e2a06f7d2bb380a0"
    sha256 cellar: :any_skip_relocation, monterey:       "72e35719061bb59a475a6b433afdc052932a175a45c6c8205e05bccf100b76c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a8684a208c64a3ac4154b6c1514cb0d838af2217f22dc01cea108ae1838079"
    sha256 cellar: :any_skip_relocation, catalina:       "65c093d5c8c6e380b2bc1d859b3c7053b7d935d5320da224dfee5aae35b19399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f849b646eb265c3c7a74379f7d59b0e5ff7ac59c7928b24794d9ba9bd061370"
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
