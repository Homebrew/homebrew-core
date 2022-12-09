class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.26.1.tar.gz"
  sha256 "f2c0e01e028cfdae5e6186ea4e1099e60c146e2197f37b807ea8c68c59c07004"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ad3ff631c1253b3113555184a1835a8dcc6928f2121ccea2cad976a50e81ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d7a321c62cd0c078e44fec3359d5788c0f53aff7894d20dd6a7c82afb0ee016"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5aa620b4908e3b949d41a4e349e301a9b72ab967dcee411985304b21d44b759"
    sha256 cellar: :any_skip_relocation, ventura:        "5155d7c3feb82e105c35e8f53742fc5666e72fba0534ae231a41d1dfb50b4d55"
    sha256 cellar: :any_skip_relocation, monterey:       "a91869cbc8db37a956c1521f7449008322ba09de0cb2377fc8e99f9befcb20d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd6962dde79f8815aedbdf90ca558c3833d54870c76d0dfaf00057751df25ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7368d7e7df6213242371277d6941e6bc65bbe0e853cb2277d248faa0e41a5b9c"
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
