class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.3.0.tar.gz"
  sha256 "b86f5d0070a9959baf79bd672d9eed2122de007b11b2377749da715d147f95cf"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd91b50ff1c6e97065c783567c9d03104c7ffe9c9dcd2eb0cf11b92202181d34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d34a05c2e7f91e0b898cb41939654fee05c7868fe82e52007474feec99fca4b"
    sha256 cellar: :any_skip_relocation, monterey:       "317bba280beb947ecd06f3d2f3a54dd24438c8c899ec457c6583110e3dc75514"
    sha256 cellar: :any_skip_relocation, big_sur:        "7826c6e0752d2a7739f3da570ed93eb2a5010f5da85e4c96c50e1f00d835d72e"
    sha256 cellar: :any_skip_relocation, catalina:       "e1f1340000c5c0e67cecedcfb6c5a0b2be14652e6af434ea702c074672dd4c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa6c1c140c56ab7dec9628579f70f878b3b1e7275ecd19202f1a0936ccf3bca9"
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
