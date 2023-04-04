class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.25.0.tar.gz"
  sha256 "725b995fc10e15505a587679af735a1abe854c5a0c7e040288f19a18e35d58d9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0acb19000f860acdfbceccc213ff2945327449b118decffbabf6a65ccdfb5b23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b6240e8c3a771a8e1ad9643e844a8c31f6a34f63b9d07dbb5fe612ed7a1fe2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d968f609807b0a64e3001d8a1bfb1d4a8cddbc575c631b26476596dbf173cea3"
    sha256 cellar: :any_skip_relocation, ventura:        "448039e0fefc51f83ad045edde1aa4bea3e5d8c6cbb93f675037c2df44a187a9"
    sha256 cellar: :any_skip_relocation, monterey:       "25ee20c734bf4c56e8e22b71e7b1f2f62caf7cb95d94e98b6d6faa27842024ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "4899d343e2b8406168fe040eac0293882696be2f4ac55ffb8e8e79d1d88d26a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35be16ff3f555c4376feadf6ef5edcde4783d042258015ad5d9ca30adc2e158b"
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
