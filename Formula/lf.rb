class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r27.tar.gz"
  sha256 "cdd132e33387423ef9f9448e21d3f1e5c9a5319b34fdfb53cb5f49351ebac005"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff891643a5a8075a7b4f91b23017f11d21d42ebfe07cd542df75645e09305276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553d6cd7611f20d4289169c789da8547455cac8f908dce4e042c13d169bd9e05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b132e93f46cec73de1f3ac8432adf1cc88caf97e9e5ced9a89b562cade40f956"
    sha256 cellar: :any_skip_relocation, ventura:        "7ceaf1bbb130e3634e3a12187b4d477bd9dc7bd97285beb9ed0ecb9f76b31d30"
    sha256 cellar: :any_skip_relocation, monterey:       "d80101f720ccf3999990517874f3faf1fd86fae17f8bfc4e8a1eb4508a981859"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb8e3ec6c981fbfd667eedb21ee77dbcb36d68f9162cd2d9de7599b4a4131093"
    sha256 cellar: :any_skip_relocation, catalina:       "5b6b86a2e7e36528a2dd32647fe5d3a9a68d542f953aea319386e51557e5a25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b9d1b1eed42aeecd6b4d94e41277c89b8a09ff991d95374cf9da67efc99a18"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
