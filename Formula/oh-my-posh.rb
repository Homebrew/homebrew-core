class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.74.0.tar.gz"
  sha256 "967cb1807c3d4773a20d89a1d5f9c49494b13a2a49a2f188405a80d2c63d8ed2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1b867d97c2d48f3bdf14be2919c1260fc1008f3bfbeb8302d8d1f1daae956e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af6dd1d9ae2a0937aa5d25f661b8316595fa9c9675225e8c1590936a3f15b28f"
    sha256 cellar: :any_skip_relocation, monterey:       "71a4f834a057b19cb6ee841e2e2508cb94755f9e72b0e82b6266cd19163da171"
    sha256 cellar: :any_skip_relocation, big_sur:        "c68b3160b239b19f2939672406a64a05622bf6f396e3e5d8b5d607feecb224aa"
    sha256 cellar: :any_skip_relocation, catalina:       "fab2b099b4825f744fad73f7593ca359a554139e4d42e9b412791bf2df66074d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc64ff5ae011d008d406d13781d76eefc7373ffd464c9d1502c45d60836ebf2"
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
