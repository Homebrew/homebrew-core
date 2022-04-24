class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.71.0.tar.gz"
  sha256 "f790bbc7cd18f91b4e56e046a2788034dc983d975bdd2c427b0fa47255413847"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4067b1a47013a6942d213f4d6f7be49668ad7aac91c5f655988e0c73e8888d03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02200de36a68c7c26538c5bf3d9e8359d9ead4ce14c3068f7ec49d57b4b3fe48"
    sha256 cellar: :any_skip_relocation, monterey:       "091e75171c84c91dedf5c05bd287c2414e7982a7fa3103790498dc3677d3db5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec4505c8ee140f8add1de608038005021bc1627a82f4d5ad55a4a6fef6ba0dc1"
    sha256 cellar: :any_skip_relocation, catalina:       "946ecfb64e3f6465aab91e07b2891d7de16cb58cbd3cbf277c9660f88be1152e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "072733b974a10c4707da4595f1b11f575e40d5726e64df5128caf79bc2106780"
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
