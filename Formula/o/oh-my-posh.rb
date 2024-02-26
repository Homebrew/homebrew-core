class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.11.4.tar.gz"
  sha256 "6576153b05e5144a86fe7943f22e848d127bd08d6d3834eb19220de4b504b4a5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aac4a141ef45cb79085ef409c02601278dc0f04eeca9c8038ced24828773f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db1a0030ec507d55b5535652851adcb2888198844616ca6140534cea42be0e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a733a839a69ac95b85e152904c112a7d872d3b074465fc37bfe01a6b750e45d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a304e9281d399a83a39295088b1a97635593d3079edd14003c8d3697cd54a78b"
    sha256 cellar: :any_skip_relocation, ventura:        "823051955f96ee976031e81c5b6b0b31d79f36f9826d1c76ea548fd008c92591"
    sha256 cellar: :any_skip_relocation, monterey:       "07711b5afc5985e5a6a871cdf3013ffa9f3e80a097635068a5f14b728cc552e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af888acfb76f9a23d4fbbf215f5e943709c6c5d654ca51a3585e3fb570be62d9"
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
