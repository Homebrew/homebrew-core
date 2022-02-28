class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.27.0.tar.gz"
  sha256 "1bdb6663f92bcdaf2afe645e798acaaae6d4df0dc3da1bac9be9e9202937efa4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2a59d1cc41459121dc83df1a9d710553da4460c51307efd823370ab1be9540d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80cf8cc8a3e8e6ae7aed09a425def6af1c55227f34f10c7c8d6253850555f933"
    sha256 cellar: :any_skip_relocation, monterey:       "4d121c42bda6da9b2539a541b8246bc15d7f77c517978abb7500b992873fe4b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0059136a1779c73fbfd67d5246c4db7708846d1c9112193027cb180bc967c9f"
    sha256 cellar: :any_skip_relocation, catalina:       "a521d0bb35b1b25a06b4badd07cfcfba2e788e6f34f79b6de40f33de37d63da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5379a83c241d3841f1e3911276c36c2821c0f3d07e82ee72a18844ec7179394e"
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
