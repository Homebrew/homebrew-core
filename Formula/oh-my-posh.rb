class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.67.0.tar.gz"
  sha256 "4675d780ac7072a1687de894a5da066c89b7d526fda2005f4d5ade9e8271ea71"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "527409dd4603e77b5113c9132d431c9e73f56ff8703d183a090132cf271b1c96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "986b6e9b385e390bd80bed3e3a29ca48dd2b8200d8b8b566cbe748d5afc5f511"
    sha256 cellar: :any_skip_relocation, monterey:       "aa62ca4ece5b2b2313b5edc80ee4f09b45f22d33f26732c0d0956994f7211a12"
    sha256 cellar: :any_skip_relocation, big_sur:        "074d56ae7b84c3cd169350e8546d66eba87755b9d8e58be5c9ad3b06bbfee41d"
    sha256 cellar: :any_skip_relocation, catalina:       "8ee585547b5aadec4443f0b9951cf85371ee6e6bd1116adb021b7d7bec39f2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dcc50286fecfbe6d4cd7c969f58a9ef16a129332ee76c1b11132a6188341883"
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
