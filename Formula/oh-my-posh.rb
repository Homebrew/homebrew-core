class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.36.3.tar.gz"
  sha256 "00c2a8bec7dd78c5cb574d831ac6a71856beea26ef4849f0987781409788d8d3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0161539101527ac0840bc9b27ac025e52ff322fbe0816663f4dafd21ebcc40a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57fe29a836b1d9f0316c4445458239730d9d22222be422dfdc7072aa0209cfb7"
    sha256 cellar: :any_skip_relocation, monterey:       "bac5cba69c962337a2c3581f5623e1a0bf096545bc979cacbb2e6ad95b70c425"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4327f4f1a47a253163932f9ad19826d86283634f51a073e516ba59a0afb4135"
    sha256 cellar: :any_skip_relocation, catalina:       "7a14e822b98c0639bb3f3a7b56ece4f261f9ea455fda2518223f17df6c5ba89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b79b873fab54be996a196ad99fa5d20aa9e0d28438668b9161f754c4837cc0"
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
