class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.79.1.tar.gz"
  sha256 "8018b28e00740ead9642a4cc255ae8550a7561a2f406683136941651baaa118c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8b0e8fc9cde04f0003ecef62c80aedc2f4376728db9b7756e643d0c81716967"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3c31da696f47c284e6df919038e14a010fb6f875b89309133ef04b7c92fba43"
    sha256 cellar: :any_skip_relocation, monterey:       "5c1e04bca1737991efae9927da961107430963243fbbf50f4c38b73ac47b2b90"
    sha256 cellar: :any_skip_relocation, big_sur:        "7251937a34a96dfaaf9cc57fd110b306d9ce0e20537e3d02a58351a68e88b82f"
    sha256 cellar: :any_skip_relocation, catalina:       "753d65522fb0034806f260f897347cc0aebe9bcf09041c987a7bd95cd1003dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca18eacff2663cbb67f17f3a8c6189fe22373e4719e85b76d966b7e728bfebbb"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
