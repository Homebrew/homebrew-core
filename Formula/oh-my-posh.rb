class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.5.0.tar.gz"
  sha256 "f9de7f4734bb3c329b195a1ff4b66ba2f138cac4eb6478d25ace7cdaab6064b7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ec67ff7f80bbf1685f8555096b09e503ced81bb7c2b27c4f3ec832d6ea7deb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4ef95506cef57efcfa026f9c8aac6d8f73f669326a7f7e43c54e8750dc5b8b0"
    sha256 cellar: :any_skip_relocation, monterey:       "ea06cfa173c72211d57eafbcee90417482ded859915f90712b6bf627f7cf06db"
    sha256 cellar: :any_skip_relocation, big_sur:        "449317513619ea890db6d174b5d4e22376c7d0afaa62ff0de63e7827f74752f9"
    sha256 cellar: :any_skip_relocation, catalina:       "343fbaf7d353e4c42dae60bf671cbc823314270822e6753b5d61b352f36fbd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa7ac762281d7ac863a0012c2f2f57a7edde910a40fc80fe738f1f0b7eaa77b"
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
