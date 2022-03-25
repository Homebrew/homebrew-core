class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.49.0.tar.gz"
  sha256 "ab028b2a9d25b44fa278b7ebe99e443ec40b594d7f60986a1a59b0727121ce98"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0519a487c6f73cf74f1186a2ff48b7327414c5b1e55335f5c7c65fbcbd30b800"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0eae9ec561eeb8271902b487305b6a1ac11168cefa5fb58ef384e413ca210378"
    sha256 cellar: :any_skip_relocation, monterey:       "c13db31a90a2c7e471a2d3e25eddc634fa79b3601704a2d01894ae8995c5b126"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f88cdb6341492e559356b7f9040a931b3f7b4cab843ef1dfc2b30aaefeb6dfc"
    sha256 cellar: :any_skip_relocation, catalina:       "b713e4b7ec01ddfc475b1107cfd09c1c2c10e9a228517da1760aa2f98412a687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a752a9b638b80433bffdec006cd782d132c3489000b0be60b12daa227ddbda5b"
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
