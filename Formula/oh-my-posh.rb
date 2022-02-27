class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.26.0.tar.gz"
  sha256 "0f6aeac15f0251d30957d819025c3a3fbfdba99ad73e607cf51439eea0f2a444"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77874fc495e8c45ea8eaffe06e31b15d9b7f7e789a837ed49b3a834405606952"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ac0a9cfe282137b0a87f25c3af9daac868f0d3a303b2c8943fa177edf6655de"
    sha256 cellar: :any_skip_relocation, monterey:       "84344f19af512fe343202cfedbf7047dbae44eb63b3e3051da96d62245b1bcb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f309869724011fbb386f4b3fe9bb85b61e06e7539073175b6c9dd9f133c0fd4"
    sha256 cellar: :any_skip_relocation, catalina:       "f768c78f11fa8f9d73de1190e0e1a9941a1641cb36c77a76391a29fd2f22d46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b3083d8c81eb72477105b1155229792047bda10a409d4c8454f142a46876864"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
