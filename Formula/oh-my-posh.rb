class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.33.1.tar.gz"
  sha256 "8f74158909f302ae227257066ff927c3a3021ec98c1a2716403f5ab22192a0c7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c94ca34e76714fbb958837540663a4cf13dab82542f315ec6a1a37b80a01da6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e877b30ee80ec3cc5ab4146d4dff1dd1896ec100019db4874da0602a3d94402f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1012b0e653d604abbf3866c164da02fe1a1d2682f5d6616728e482ce79f82d3d"
    sha256 cellar: :any_skip_relocation, ventura:        "304acd757745edeea8d0e98c9eab9424dee059e3a2be2278b34060462e9a6734"
    sha256 cellar: :any_skip_relocation, monterey:       "a7dcf24f1b8dfb4ad9d0c1cd3c3712e1bde9bbf6a683ffcf0d830f56b0e84d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "839d3f0644f53f1968387b8079d60288ae2cb851777f4ceb99add8e6fd2923aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bae545bc95ed2b4c3f861e0add5c61465ade12ca3bdcdddb398fce43474a1b3"
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
