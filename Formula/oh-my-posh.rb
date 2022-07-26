class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.4.tar.gz"
  sha256 "c20fe835e38700ba7dfa4a2a368f66cf93bbea25bc929fc7ea72c15da62454f4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860509844295c5436eee01f9a45f179eab8152261b69ae5328e256b4d19de10a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eba910affc76fb199163eca96364b2b84e564c88933d3c0c9a416397a3b08a2"
    sha256 cellar: :any_skip_relocation, monterey:       "5d14fc6ce378bba3e2c138b40b304ec2663da487c1af0326a5f19e11fae37213"
    sha256 cellar: :any_skip_relocation, big_sur:        "6028ab86cb24fbc097211aeb9047befaec6cde00179a1c59b6f0e075182a4126"
    sha256 cellar: :any_skip_relocation, catalina:       "35e693b2bc9409fb1547ae6412dca02423b9f7af00b9723de04dcca45cef4f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3a2a4102c294ad9bedfb891e21c3cc7cb19beca2588e280d5c05c165e5ea63"
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
