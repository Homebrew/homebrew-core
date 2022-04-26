class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.72.2.tar.gz"
  sha256 "1f3b4705deba06b3051917248f4a47a884c5ac95c40e008c0c99162422c8e3b5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11359b0c863251f462b0c925eeebc8d263f4e0b4883670d5fb7f4bf22b1e6a9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82e3e2e1cba9af04f79a268868dae30b599b04120dcb344e8ab2482038a748e"
    sha256 cellar: :any_skip_relocation, monterey:       "e300bdf11207c691ebffe2399b5e427afe8828b3d18ab2ef5e2e807779a27e4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "22b1940d03d51ee10461ef9b1d7c68cc46e2335f7be8f3d3ed2a662c87d22a0a"
    sha256 cellar: :any_skip_relocation, catalina:       "129cb0be3e57bd78bc08b68828b8539340cace3ec032c3ad978312221b0ee827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c76f84d1d6fddb7f44fed9b8987dd5ec3c5d17fcac71baf81f1cd8c741440b3"
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
