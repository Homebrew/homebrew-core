class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.0.3.tar.gz"
  sha256 "ecd6ba1f839b3143b9f3cb3755eb87da318fab22ccdae95a4ec7ca1ee872fab3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "678a9a4d7b195dd19fc673628d3dd7ed49c271814594ea4e255f943a51c4245f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "208ea5fe53f537bba752ff633b7266cbaf6b9d1f3f5ad245ebceacfc35631761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05a765deb34100b8b001d95ce156d497210971b455747b624b8ed8dfdf5b8654"
    sha256 cellar: :any_skip_relocation, ventura:        "507a7ff0169d48cd59e923f8122595a28bc46afeb8867d529b0b77fb00493f24"
    sha256 cellar: :any_skip_relocation, monterey:       "e859ab97be1b181ca4403489f89e16470bc3453dc054b0ea13490e5d8063af99"
    sha256 cellar: :any_skip_relocation, big_sur:        "24a737133e2391d5bba84439a5ba9834d41ff16c4fce612e7234e58c1e7a6ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d4eaaa7739a4b14d1ff964a25d0878238dd9e3270d76e6245a0efe0fc29680"
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
