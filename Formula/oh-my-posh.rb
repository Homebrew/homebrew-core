class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.34.5.tar.gz"
  sha256 "54dbfe94be655362a310c3907e37192104154c4a7a5aa2d1aa068dfc7c0b120c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44a24f585f430c17b669b32b1b0a647242c5f8564d6916543549317d76fe4a24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f3c58223a5d1abac83099ddb45e34e9a90f60f4b5ecee1180320d11a0b34343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43d0b4c8765578a70cca51e2f998c32751e20d28528e798aca8d20e6bf6664b5"
    sha256 cellar: :any_skip_relocation, ventura:        "baa5d547306855d7e697d06786117b93a3a8dfd4ffce05c32365f57fd9ccf72f"
    sha256 cellar: :any_skip_relocation, monterey:       "c898914de958aa0dbfdfe03bc4b3a616879c678b31d342fd0487c8609fee6e3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb31610edfac35bb3d626589827305e4199ed60efe668dd0c7ef9d17add6e5e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0978be92cc14c45dca2cadfa9e8e68f72bab6b437006c8a6299959ddafc2b6a5"
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
