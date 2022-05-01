class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.76.0.tar.gz"
  sha256 "b5f8872e627980e4ad952dc79b1fa41fdfc13a77ad2878d1d4bc9f5532551360"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f92b89992bd1f55684ab0806a67832b170c785474635dd0fd51eb85fe76eba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88aa10b1c79027a8066ff50a5f718c30fee49430df58762fd31ef78781a3c80a"
    sha256 cellar: :any_skip_relocation, monterey:       "348d4cd4bbb6d8a40317adece9485d13c80bb0ceb0be21ed25ce8aceea497321"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ba7ebd883cecf4547960f276ed48eeff695fa8de106f5f9b1e640491df53643"
    sha256 cellar: :any_skip_relocation, catalina:       "4950e0670ee04e8347e492351919a7ec4794a61563db036ec1ab6823cf87f430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d36043ab4f6ccc07a8ea1d5ba0e0f5f8a11203b772c6e98451c03f4f8b2a8797"
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
