class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.5.0.tar.gz"
  sha256 "18b3a8dd0b1be3c03e4822ff582bf468086723c444663b8220ea038278d220d4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "158861ae226b1373a1b8980edf1316819d8001ff9048be3a046e54f7b9c7ac91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc032add3b987b6ffcf5a51220a2ce02de6dfb3feaec60af23d8d170ed7e531"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18f9c78a2b429baaa01b10c2f416b41f1c93e7c837f3a57eaa2f16e0c7499d6f"
    sha256 cellar: :any_skip_relocation, ventura:        "30b4fceeb465c275b91de00382a9e16ae3745e059c4982a21b9e37796ab9525c"
    sha256 cellar: :any_skip_relocation, monterey:       "a7c6a7907edd0f8644a05fec42a535326abaedd947b72d1833345aad9143a5d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7897a7a9422d890b3adf1eee91bf48888b2fd4a4108055518a9637441f2fe0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80adaca37bf9916d756479d2ce652689cd6e8b31568ac0cbed8eb3b1f4177ad4"
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
