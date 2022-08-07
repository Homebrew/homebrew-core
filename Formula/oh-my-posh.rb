class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.29.0.tar.gz"
  sha256 "e835476db232ddb274fb3648fbd4fbc823644cbee634d75fa4c5a4e19f7ffbf3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff4f8f43449e93f2c5a4d3079e96a2d5e1f6098161356208f7a1df70e958c52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8e22d98c407b1cdfb510a987f2fcd72ff356499b7b3a9ebb94b31e8264cb52a"
    sha256 cellar: :any_skip_relocation, monterey:       "b17fb3f62e782543336bbdd5d45b2525f0c4679b31e6371c2d6a5cabb817b44a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c42c06b29cd35ab02a21d3d8d6a1370a93e624d6dae4933305eef2d481630de9"
    sha256 cellar: :any_skip_relocation, catalina:       "529bebc18e481c282cec59024b24bbc41e20c0ce0841ef86a8dca4a3867fd3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d49e0f6e0b698ffbfb7358085d7943bdd6064b8902ce27a2e60de78248aa141d"
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
