class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.21.1.tar.gz"
  sha256 "40bafd48352786cc9a49cdd8f39980e205ae4863fdbe374788fa604483523f16"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b50b6d3644d6e170d6f749ad9e7c03a6ec3899c0aefde042b8b967d88678a319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "331ff4a8fec5c95eb549968dd3a3cd9bd1a8b2bdeb85b72487b6098db9287405"
    sha256 cellar: :any_skip_relocation, monterey:       "44508aa4896c677bc3fec64311644c0f16de4016aa05103ff8cf2cfdb33e0e9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c829e9fa1f71e4b9c68fe6ad4d494fe9fb99a969cd3043af014a0b12358d66ec"
    sha256 cellar: :any_skip_relocation, catalina:       "7ff9d37ece16661e55e023a999154ff1a8ed2a1b04ad8d30f53cfb9500d4b227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da52ca87311333e40632f5d760c4c32ce17b60a5c92491935ea844acaa4598e6"
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
