class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.28.2.tar.gz"
  sha256 "2afb623fb2ac6b7d5a072e877456f44bc7701a1403983a4541e1e35e43ab8956"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e29d5f96e00a8c0f1355dfaf5386c77073d855a8455f85ef92513b68f3a5140c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77782d9bc6aace6ae38de6114a186aa5af7cea68bb0a4d29358a84a86cdaa8ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa3a37afc851c790578a72b63e77052cb5783cc53b79ef78ab654d3bce0ce92b"
    sha256 cellar: :any_skip_relocation, ventura:        "6ae13887e5bab95f83b488637e3b7ad2b97e77e0b43725448d4209710bea3e1c"
    sha256 cellar: :any_skip_relocation, monterey:       "bd45ff02a59dec853ccd59279ef61d098640e05332b95f87f8af0f80346053e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "db5e96f3a18e6f3f4a87301a64953ba20e526422b4ecf26b951f2594b241da2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c4950ed55166e0fbb74652db29d194075fc5d42dd2e04d3fb40b0c1ea62ecc"
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
