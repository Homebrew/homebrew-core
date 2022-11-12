class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.13.2.tar.gz"
  sha256 "71048f82b166d88ac88ce3ee8450dce67698d548df460f9333073c20f4832954"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5c9c627cde858bd3118bf8864bae4083ee3a8e631a1861d6cad0d919aa9ffc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3eb17b8b0c838e1b04fa43a89eb9b20e85fb130534e0bcb7d7b223cae2ae70b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0132bf00f771d86403773fbafd2bcd8866da76c4f4af550ffcced3847811f3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "d6c7e38ada528940682cc4869a6855b68004523fb62ba9cca49c51dbe11956e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6280c5155a35673206807ad22d6f7626f45c373e0a8629b3ad7b57b9f682402d"
    sha256 cellar: :any_skip_relocation, catalina:       "0332b2af3fd385d6d92dd3b0fe10a3aa9bf1b542145557180dc8e859cfe0e406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5181c024637aab63c1ad87d24129c7e4d5b7a8e8b6b0be6d961e0bc9d9d93c9f"
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
