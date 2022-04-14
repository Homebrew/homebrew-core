class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.62.0.tar.gz"
  sha256 "b4a3251bdceaaeb08ac0106b5359bb5dca054c0c6a38153ec3588d8823367753"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1465bf4fc7b930c4dd50776d76e08dd4eb7f370d868931b9201008f2b329a67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "585d4b922532ae0098b3e83e463fba9b1bd418d41f1bf1d4ddbbc77810b539b5"
    sha256 cellar: :any_skip_relocation, monterey:       "c855174b012e9add42ea4791ecfd8f699dd5ebcc1781a3373069e498a6f8dbd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a07305c97782af57ad47ea007f123be9abf0de91de3c39de48e350a5bf7d7734"
    sha256 cellar: :any_skip_relocation, catalina:       "4911a83987683a4ab8e358b7526a6552382c64d1c4442dda4582bde3988e2bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b11b28755a73edad0ac08ab9d27e3610b8a57ef99263729e9ec7618c3c5a6ac3"
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
