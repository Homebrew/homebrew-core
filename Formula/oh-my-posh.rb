class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.35.1.tar.gz"
  sha256 "cc96df134568864617d2afc4ad3210ab9a856345b35c75c6c390a10d11fe52c2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b3b615d5038a1e0cfcac506917014efde0dd6daa07a09a585a0d62bd76fcdea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9977da6a0fd20cc13917fd1824dd4aa4200f12ab541b19412b29eebe28144b5"
    sha256 cellar: :any_skip_relocation, monterey:       "01bccd83f357e34f6a0549a2d98433efd8e96d27158cc903c0c82448b89a8d96"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a5cdf134c20e9297b78db7707bb895fcf44649d65e20b7722bae4ff8dc166c"
    sha256 cellar: :any_skip_relocation, catalina:       "1548c54b247c476886221b94c5c4b8b39b0ae52babdabdd857ac32ea9ac1e498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f589a62310b216b740b080801f349a379d2391f6d6b5648a7de41c1d575732c2"
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
