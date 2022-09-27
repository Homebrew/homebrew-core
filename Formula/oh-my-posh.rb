class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.1.0.tar.gz"
  sha256 "d923bab170ce73f1fc56f26d48ca327453601f4aab9adaf1760664d26e68f8f1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "931cae61e485ee3ab9c3dbd8962a151062ec73a4717a44fc6e5f04ef9332bbe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2126e340e48bb23e1569482232f662c17f391f962e35004ae1bebf864eae59f4"
    sha256 cellar: :any_skip_relocation, monterey:       "367ecd1923c1419693f4000047bed5e9c18c34cc463a68c12a55e7306aec73b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ed9f3e4c99db1988ebc06071b6ace8cdf5994a810d1c75d9146cde65b4b87e0"
    sha256 cellar: :any_skip_relocation, catalina:       "32646c108fd40cda8fa356d1770e2fb1be79b4b63b3a825db7f7a1274129057d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce0432340e7fe38d2cfe8088ee9e346c1ade58c815533c081c7bdeb04bc5fcf"
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
