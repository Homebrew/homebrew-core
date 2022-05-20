class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.85.2.tar.gz"
  sha256 "40c6463f37ee67933214527c9ee8274db9e1aa0e9c90e3fd54baab5f1c58b3f5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc926c04e64c6002b5a7ccd077e7ac80919c477a16dedaeae26cd828f2e10c7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19fe1b95f67d66367df5cb1a8409a6239a8e06fbb3570f71e6b29465a81fc759"
    sha256 cellar: :any_skip_relocation, monterey:       "62f757ea6bc51e2e1bf0ec5b0b7cea6e0d2983049acc98db9104d57894af286e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0436581ce187dfae0f443547f0ed3189bb7d3adb0af253a291c7dbc5a3e4ae7"
    sha256 cellar: :any_skip_relocation, catalina:       "14bc747ffa399f91a6625f1b96f794aa7388a97072932b1a6b51c9967785f4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf9caf646a02d788ccb4ab6b844ba4f131897b1a1a08b5e904dbf4f0ddfce77"
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
