class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.7.1.tar.gz"
  sha256 "13c570ff4ac0e97f6ec15b222fc4e7a79e395077635a3763dfaef93033fde3fd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24790676117e6e2e68def2fb12cbf26f29c0b2b4c2c6905000c01c7f2c0b3ded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c907425afd99eea64279b6ab29ecc3f2b5a4b83d090773f8aa394aaabd01e08"
    sha256 cellar: :any_skip_relocation, monterey:       "1ebf7149f8e55ac098516025b1af5199232b7957749e410d4ceaaeb2e20f5b83"
    sha256 cellar: :any_skip_relocation, big_sur:        "683ec6a24c0132b14b75cadea9deb7c143e55d368aa346da258c1bd75d6a1024"
    sha256 cellar: :any_skip_relocation, catalina:       "4978034a6837de4a96825516ccf17a877a3c445655904742d9daf24c69af69f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1554afcb8c513db38c5873eb7492ceffff6b0bc03351f1bab1348635bdbff45"
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
