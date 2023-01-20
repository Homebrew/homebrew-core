class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.4.0.tar.gz"
  sha256 "1ba8d6db96056bdfb6855757cc264003a2c8afa91c8f8e4b56ef5c4c78f596c9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f6932fe4532e15d827278260a90da7f869a65e4d25390f906234c534f1ec792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ebbdd59e9f3e79207bdd20f2fc92fbbb89ea79b8241bcb87c335960a93caf4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d60cf6cf42feb59887635114d48b18eaee9bec15b385da047d4543eea339d8e4"
    sha256 cellar: :any_skip_relocation, ventura:        "231d1ae0154912d3db655bdb17640b53c90045ac5fd099601ea8a7a2034fbd4e"
    sha256 cellar: :any_skip_relocation, monterey:       "5082dfbc7a831867efac6e7b6eff1e154745dd23b3db160beb3c69a9c77a38c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b760660ee2129d96e50da49f527a0cc0035e61577ce62ee191b5ea70af9f223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf47b6ca3e84d83c28a0b13a4b3d4ba0157547bd276f5d31e3caba311c6ecdd"
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
