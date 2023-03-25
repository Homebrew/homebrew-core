class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.19.1.tar.gz"
  sha256 "fdd7e4aa14c5b47ce797c4b63829f09fb7b679d42c609445327280cd2488b0c6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86b59b9aa2deee62e512940dd4ea7888a70491cae95465ed6bf10974463e5f13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca3a62cf2be43716d702a97ad71f786d55214f8101f7a7e6b6235dab0a55b780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f68d429c92979e35505f458460c5a713c24dd034aedbf7d64ba1c599e3046f5"
    sha256 cellar: :any_skip_relocation, ventura:        "e00b2611c6fd38b1948879721b8e65d191448a66d1bd0a0ebf454310b2763a46"
    sha256 cellar: :any_skip_relocation, monterey:       "119fceab69ff3c4bab388d7b65c2f7c3b7a6edc0d77bc73c40c185c506c3b639"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef9c35d819267580c415f86aee9ac8c7261f6f793520e736e0482412af3bdf8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b96126a4b337c5e285f94d38d1de8b3f48d615959133ae7afd809aaf7dc7eff"
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
