class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.14.3.tar.gz"
  sha256 "ba72735be0733988c938cc345d789032a32ad78100c53dde8e3e79a27a5413e9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8952b66b489346e4470058c64dd52d1b47f3d3126cebdfd1c651be326bf9d3a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f21a1c3b56e6b1714fc4ddfca331148d6c1fcde58ea4ba138db4708407f1445"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10bf3f7b3e557f63e1647bddbc8c4dcf5feacdce19f352c47526148afdc6e16d"
    sha256 cellar: :any_skip_relocation, ventura:        "d028ff179529aaf0dd48dec4ceb489563ec33370cdb03edbb946bf2822d09641"
    sha256 cellar: :any_skip_relocation, monterey:       "7ed1d0808f499dfb48a64841cefcd1675cfbddee3f4e72efc1d5fc5dd61d8c03"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa2aaa326fdc3906cbd943ef8bc3406a521ec186bffb330dc852fd9199de1eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5edbe1e54d86185248981f8c81c1f437132ef390683143147813131a264b7e36"
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
