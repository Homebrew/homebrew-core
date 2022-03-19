class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.43.1.tar.gz"
  sha256 "630e1f0de01456a6baaaca4a7ffc5c8cfb51351a9c1095904ab6d791d067e67e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba09b10b8493cdf35c55d55ae6f8fd21d49e5a2b7b046525a98dcabaa8de417f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da6d7cf51ab07b320d08e18ee3aab41cc4a0b6e6d87484804782e721b359f7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "5218f0412cee575312418ddf44437d1598209041a4d15457ffc681f9c2c19f1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b1dd359328934fdeeaaf38491c888a54c19ed3de8a4e80c8c0d3b7eaab69089"
    sha256 cellar: :any_skip_relocation, catalina:       "2a0ce16f0a72a214c87ad98a13b7bb12437bf84ef66590769882085d807f9cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9757936afbee8be0fc79e907d554d07df2443bad075db58df5dd2810c659569"
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
