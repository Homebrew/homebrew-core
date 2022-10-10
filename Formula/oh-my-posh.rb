class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.1.0.tar.gz"
  sha256 "cbacfc77f61bdac5431e1794bd4231ec3e6fb7de67a4112a1ae7d7bd75f2eec7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcc160896fa41a723a54f3049cab6c98acc0aef7c3a0ef84efdc55f714db0534"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c7baf638f1cf8f5a46b32a2773208b79c648c3c7bfa0c13a726bf730dd722f1"
    sha256 cellar: :any_skip_relocation, monterey:       "0fdd528534dafdd3b6738ad3e4165018a790486e9dfc26856af5d8ec3981f4a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ea1063f80bbfa1bbd083becf2937061c0c75616487148a8e0942e9cb1d39935"
    sha256 cellar: :any_skip_relocation, catalina:       "2ec4b15bec249d545b3ae71887baf89bbb5554d557b1096f1d7c081240ebb0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be9f8d0cc04e624b5278d1d39af5cdf49195e8bbedb16415d18e76b7a19a166"
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
