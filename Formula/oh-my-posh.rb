class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.26.1.tar.gz"
  sha256 "e4930f01ac4e1bf5769399b7300fd9029a48607737a56071f6109655a6e4a792"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036ae241ab7392e59448b0504f276786975d6bf698408db081ee9f42c9981db6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d3b0b7ed3074f96aad0b80e9e36a6e95b974bd6788501e2f318fd9750e926f9"
    sha256 cellar: :any_skip_relocation, monterey:       "6d6f2160f240ceffe0959f73900422caa00efa0bf735c2f40bded019308cb388"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aece9b86d90d839fd92f51a9dcd2bc1657861ce5228299642cecfd1d927a055"
    sha256 cellar: :any_skip_relocation, catalina:       "bdd6920d3c58a065913f7a7ea7930850e25aadc8e98f105d8cbb5b50c5d865e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a367190e7f2de31780d67215e0d3f902d6d222fe83f99eb3d964564a99f70d3c"
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
