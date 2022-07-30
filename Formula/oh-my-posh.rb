class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.24.0.tar.gz"
  sha256 "09d64079bf21b0a46d90f18386a9d4929949a7a96fd48802db744bd069220a61"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b42dc08e20d3ff64b30fdd67391f2cd7f91b627be070f04a4af926cd6863cc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d48247ba38641f8e7a3ca1c367e3709123c69f507d8cd7b9deb9b234fed3f17"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e37de6a2fd5969600f9110aceff3e4fe30bbad743793f811c46c9357a84519"
    sha256 cellar: :any_skip_relocation, big_sur:        "51071e8262b9c504ba9f37efd8b1fa47e53ce2a6dcb68f0e96c017b2224960b6"
    sha256 cellar: :any_skip_relocation, catalina:       "404ab1f0f2832aea4cab71b8907952d71a29d7fb164cea6ab8f9354c4f5e2b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d3c32f398bffb8e9485d6ca7869e24f2569d79b1052bfecc114332464eba76"
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
