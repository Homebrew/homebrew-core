class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.15.2.tar.gz"
  sha256 "267356a2a55b73fe4b3d0e51b7f12925114d2e6d868b21af66b5bf02908b47e8"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd0b58b6ae4741b52ebf13297a6c41cb49c94f7b134f5d45dc829935a053fc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b493d0c67a064550ccb14902333bd671c60d393c5a356d03d8c176ac1d21ce8"
    sha256 cellar: :any_skip_relocation, monterey:       "cd0412b873ac080bee6bb859ea4dd0099a29d56adf8ce81699aa98f47996a01c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4512c42c48394f65f058ffa2370fb56120e0a5a671425dbb20ac60820daa05a0"
    sha256 cellar: :any_skip_relocation, catalina:       "3ea76a2cab05de406dde40d2832161e9b33cfb547d9e7ae5894593ab93404a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd099357ed5cc01ea24194a38b8e59ff77a5c45652f97c760c3fc0fb3f685d45"
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
