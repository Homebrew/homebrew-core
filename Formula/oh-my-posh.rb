class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.36.6.tar.gz"
  sha256 "7c45a3f608d63ab903a7f18610e655f6d557d7711402abf894d009a26b70ec13"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcde5ada01b438522603af7ec8604eba20f26d818a3dc2154d1a2624f49e3bc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd55c07fad1c6363fd5ded12048af0994dcdab20bd650f8a98d3def11b24dcd8"
    sha256 cellar: :any_skip_relocation, monterey:       "314617c2634b681d59bfafa91e1b7c1bb6972cf789e9e4558352d53a50d1245b"
    sha256 cellar: :any_skip_relocation, big_sur:        "57bb81565f41671b474d6adf5ca3ea3f075ab4f0aec77f85337a2df842ed7ddc"
    sha256 cellar: :any_skip_relocation, catalina:       "f7fe13a4049d25dd18071e49a3c9670e60d295e25b3b95e00aa1ffac841a24f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d914fbb74224abc4c412a92f33688979ffcd2f3acd96535338414bedc0424841"
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
