class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.19.1.tar.gz"
  sha256 "072a9cfb17ae159a5217eae9354ffb46872884c9ae2602eb467f59166226f2cf"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35f20ae0869f4e7b2d5ec45d620d8e79552cae5f1b76f6fc37e8e5d77e0e4521"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a134c51e9681ad600847d0fca213bcf42b79662282766333eaf56ed8f0e3b3"
    sha256 cellar: :any_skip_relocation, monterey:       "c658e80f5a22422416bc829872ad12fe9018f4de27198b71150eaacb775ffbad"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b20b4c57786e6b552b335f57306f799af2172b972b81d283094d8891d78c68b"
    sha256 cellar: :any_skip_relocation, catalina:       "875566017ff10c643a281b1836eed9562faf28514a6c0a1b4b1565b507d0b1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "174f9bc7f8df9c0518dc370021d7b05e6ee0a675bdba91d83c724dbbb7d52fe1"
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
