class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.43.1.tar.gz"
  sha256 "630e1f0de01456a6baaaca4a7ffc5c8cfb51351a9c1095904ab6d791d067e67e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d661a0df6d5a7ed860d3606e424e17e7e4abbe7d0bfc14a3362ef95cff35b478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c983afaca63739ac369adefb22aa33bf79a18f72523f0f3f47859eb207f0dc0d"
    sha256 cellar: :any_skip_relocation, monterey:       "063806cc5403f267909dbfbd325070b68c4ef500118da589a6b39648f7f48cab"
    sha256 cellar: :any_skip_relocation, big_sur:        "80841b716b4f6a7d6f94b97d7a746070ec20db3086024d3dd4b433aa0fc3651a"
    sha256 cellar: :any_skip_relocation, catalina:       "0109220dd1479ecdc41a82cca4803be7a9d09b12b8ef94b60e88762e1f84a65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "273dd2d18e0d18f445d51fe057e4cd6de0f02f240fb252777d58add441440276"
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
