class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.7.1.tar.gz"
  sha256 "a02f27f1a925a438a34a456e0a6fd1754e7b525e85e04e0f29d4f9c1e27ea793"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cde4142291d4986c3d3bfb0b304ab57a945786b0d5cb6bdaf98cb701b7d3fed0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "106ec0a0b03bd009bc5fe062981b62b5b05876b317e4a1563a1c34998082c111"
    sha256 cellar: :any_skip_relocation, monterey:       "f1552593ccb519f9e2bd78221391911ac0b7100264a825067ab05860513b3c61"
    sha256 cellar: :any_skip_relocation, big_sur:        "96c16d5ccf2bc5a4dc160796968c8d5841f59cbc5b2a56b76f233e1a0046d9a0"
    sha256 cellar: :any_skip_relocation, catalina:       "f79006bb4a8b252fff5ce1e953d174721b7b0c53e23f07ac56d4a7c8175376d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c326d7b19450d78d3540531438d5e85a923c77d13ebaed0df70f1f8e51500c06"
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
