class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.3.0.tar.gz"
  sha256 "2cf45f9eee95fd8c545a96e8185e376b8aa536e0a47125e810674870866d7041"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1559ca773b0addf89953eade069e023a6fd074ee1ff79d9d2789fefe6c1d3784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96df2b09670db7f7cb71c1c0a6598a2f26f5b58d60fcb1bd41726e9ec0ab993e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d53537873404f434fd4c39e0d4601589a6d5bdbc1ed69c33e96b28310af3276"
    sha256 cellar: :any_skip_relocation, ventura:        "8b93ad19d732e6caf0e27df195c2569f282335f7a54d6fdee897ed244930de14"
    sha256 cellar: :any_skip_relocation, monterey:       "622298a4541b80a389e0e8ecf908c3b2ed5428405e42269fcc47ac5717f18cf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbebd0c78eaba5acea9589230f6fa48fb256ae1ea5f275a1296d5dbc52937995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d88fd63974ffecd87da5b905e0ac084c4c4120485ef0f403d7fcfb36818853d0"
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
