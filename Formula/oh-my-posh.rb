class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.2.3.tar.gz"
  sha256 "486f5ad009c07442e655be0992e26273880287acd0a56b7fed7670d0406e8415"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "312c96dc2808b4f76cdf7daa154f40719902fbf163b875f8bae7b6a50ee9b2ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f9ce7769d1f038c0adca1ab4177c58c00163b799cdced34e3e9d9494b2abc67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d5b95c1e3f7e054144501ecac486ff68b2406a6e955bc0ba5019be1f184f60c"
    sha256 cellar: :any_skip_relocation, ventura:        "945a71b78dd23433277b3fb435dcc445aff93f7295eeeb7f3bde2719f370d51f"
    sha256 cellar: :any_skip_relocation, monterey:       "43f23a138805a2ffa59084ef9e65b7ba9ffe42ca0e1e7df38879448e8918244e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bc9b99565dee8f9153ee7c54dd7fa1c741c972c0b165c0d9865acdd930349fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df0a959591961a54465597f91c6063004abec11c7bd49fabb04a52095733c4ea"
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
