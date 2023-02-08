class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.4.tar.gz"
  sha256 "824e60b94f73983a6fdf2802ed5bd5b371a24f9dae49ad5e46b968b618df3c0e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "762999b2d298548d847117b2b05173f09f655399b2cdf78af9f8f71606fbd101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c00cb97a3ee7844dd362458e52e78a51d545cb2dc724a7659d8feed88fd189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e8b9e0b8500b64ce859351ea4bd8d985218d4735d68ac1ba3fe8b25f683223b"
    sha256 cellar: :any_skip_relocation, ventura:        "d80d3c835cb44c4740e866582b444aec56f287fd49404f1d18afd3440e7d09ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4bfe594e5a7685b30306f6b156b6e175d978c135300520738fc7001eaf8dae5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c1955207480c5a13648d9dda5f4deb4615cd5a8b43f07ce644e2bc667ab956a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96774f148d2521a021ea2860a34410bd7d8a7f1d11634fb6c857262085ad176"
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
