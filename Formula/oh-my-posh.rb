class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.6.0.tar.gz"
  sha256 "7304f38b72e14ecbcceaafd42b05c160ee2efc2508424de71b1cc00177c3339e"
  license "MIT"
  revision 1
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0bf11f3c4f235ac25ccb5aeba4c5542726fe75fa4874a96e12a0f7851526f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ada1d026a00703ca428c896ea0be264c3df5264d403a76d6568839453cba53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "accdaf385b65d2b43d3a1774e0683333cdfec9600f815e6c73e69e75aeac8197"
    sha256 cellar: :any_skip_relocation, ventura:        "def3d01b6c53f8119b576a2d6874d05e82d778aa689a8953349fc0946734fbea"
    sha256 cellar: :any_skip_relocation, monterey:       "8522903d2500786a3e2f57a2d01ac13a1ecc59dcd274420171a512942e9ff1d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "875e1613bc17cde47431b68e2e5d56499e391a740422aeab56ae2eda7e2499f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a2b8f7f1032503b13ac5aa7d77f58121c109399cef7ef7bccdbf91a34311cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
