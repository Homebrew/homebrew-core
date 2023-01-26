class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.8.0.tar.gz"
  sha256 "1c2342786397f02d18860322b308e7de3e1671692f102fbb0f2cad174b7d445d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8b16d3d39c860bf019bb812c60d6c29c0885f78cd3edb4b55cbb20a4b7e8d9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c46893b1df7b14ca82ec3515de9796c4ff82890d2cd37727bfd01f3cb08b871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74c987770a6e881954d5142c88561afe9b424a943920a7f16db817d81bc2c44b"
    sha256 cellar: :any_skip_relocation, ventura:        "2e00e88c1ed07352f01efa4c91e5017657db8762203ab4afcd8ace6afa85e83b"
    sha256 cellar: :any_skip_relocation, monterey:       "f0c1a35793d78bd18615820c508526096d4eabc51cab44b303b5bbf2b10ad871"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fe7a14d3ad511488c5370cbdf5928840eb169c932bf64450c2f5d698e578fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088b7b50fbcf0761edcff4e70907b1f606c8caf736f492f7e46813052a46596f"
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
