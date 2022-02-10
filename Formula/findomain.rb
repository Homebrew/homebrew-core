class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/6.1.0.tar.gz"
  sha256 "5499bf1b07be83bb2d08be43bdeace77b19a461e81fb773e2ec89f5b01b52e85"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b677e5ee3320ae5f8803d6139b3b3ab9bccef336378998cbe152094c8e70a144"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd7350f28c8027b4e80d7ee706c4c174925dcbcd8b987a53dc96d3d84ab7de65"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d4df519dc573a3c09d2b9c7d41cf46303e237b3ec271aae8c2647d3160c6fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "2905b6101f0df92e611513151e12a69e6dfa1752d8f3270e4afb78addfcac8e0"
    sha256 cellar: :any_skip_relocation, catalina:       "fbddd5541de5fb4c412391d030c876e00f91667d82edfff64ebad7dba15490f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca03aa8f82ac47d43a5e26771ca2a44b1d20052c567186c4d06fbb819bb4b844"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
