class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.3.3.tar.gz"
  sha256 "a09656476a8f216365a3338cc0de9d5f07778f31788659812674c3cfaaec7814"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a58e99c1e86a420307d3dbe995fcff688ae559b1c609a136a53b12460c3454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7dc1b6064664f14b3e8a8e05eee8b1ba9d34f362ffafa8341e262064bd99bc1"
    sha256 cellar: :any_skip_relocation, monterey:       "cd47747ea99e4463fec97a67a457e961106ca71cdfd941ea7e06d5251b23b896"
    sha256 cellar: :any_skip_relocation, big_sur:        "b61f71fd70d7f1baa2daed584f7425098a68d0c1bab6ed8135b5fa90260224fa"
    sha256 cellar: :any_skip_relocation, catalina:       "2f630854699f270c0a27d58d7313a9d3bb75c8a7aa45f4abd43f59354ec0f27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f33f7a10ba52a40d76dcffb2c2966007d9dbfd49e1e3b8becabab296dd39db59"
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
