class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.7.0.tar.gz"
  sha256 "244a9ac774f92350101c981824c4025d12ebaaccccd3c673eaccb7b2df6f3471"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f7c362f74c7c7a9911a3c0fdffccc3eee36564251946a8b528aabc0265196f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e923f259a6a1ced50a082fc4278259fd03786df8488ca046079f502edf545cf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9572e31522ce14367750aca9f8c0a45723c42f83f9e7caf62e511a3a9bd75773"
    sha256 cellar: :any_skip_relocation, ventura:        "9b662b92ca80101d375fdaab66e334fefc21fe06906415240d7845364ef27d75"
    sha256 cellar: :any_skip_relocation, monterey:       "ac472aba4d7cba94c768e6e99bdb914b015884b5ac6a7e6371c37e128de8c53f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d71b0677633126f6b26fd77439c44a74d2c4f885e0b1dd9919ba1af954aa4892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6722e3814ab9442cf5ce14e1bc6ca59969603c48b23b239495c329e6d8f22201"
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
