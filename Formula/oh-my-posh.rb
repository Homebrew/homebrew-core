class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.2.3.tar.gz"
  sha256 "486f5ad009c07442e655be0992e26273880287acd0a56b7fed7670d0406e8415"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb96d6186633c81b006fd96d0d0c6ab65e4d536ac2235eed5f4149ff7fa53297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "614f2168f05bec255a2f757d380e037f96beb33f167402753c087ee966fdc323"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91a3d3009b9e841c4aa3b617bf427ba4b978ffe337d2dc6b3f0c05e2d43c533c"
    sha256 cellar: :any_skip_relocation, ventura:        "0477feb09299908f5bab3e7d0e042172089d930d0b67954671190e06d8598a23"
    sha256 cellar: :any_skip_relocation, monterey:       "994cc020892bba84196389226dd8345bb13b04a58a2ea5c1195f3308080cc216"
    sha256 cellar: :any_skip_relocation, big_sur:        "39cb9863b5b7854619cafcf6fce88fb6ce4afa475d6cbdd266efef41344fd86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3539fe117badb99c50803e3ab8a66d7041be82bad47cab39ebfbbb90d033504a"
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
