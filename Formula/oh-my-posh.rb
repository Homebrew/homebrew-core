class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.25.2.tar.gz"
  sha256 "af9585252e5497272ccc787450eec6ed3d0727f8fd71ef3d375c5cd730a73b84"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d174e8feb6f8fd04d092b8385abe7c091e6e343269b09fdb3faa8431cdb5a606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fffc42a740e2883ebef4a46c5313d025e5833d7210153aecca067dbd2279a591"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c0334804690800909de252eddb13cab7e07b607deb14b3e1c0cc8e3d6794bca"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0a4ee36016fba8a45549054f15ce77c31a5c540206bd68a2a118e3d3134afb"
    sha256 cellar: :any_skip_relocation, monterey:       "bbecabddde10e097d3f1ac0b9b2389a81fa6126970d916ce52f5c87926c81be7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d7f159174f0bf4b5f0da763dd97a77dba2965a7b065dbf1857d321f5391b8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3b2be3e164f55a54c341decdbd267d1a16bd6b9639cf3b192e3b44e7f4fde8"
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
