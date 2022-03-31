class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.55.2.tar.gz"
  sha256 "cd1c8c985d520eb0ae28431860df0cfe26e0e7d5ca26e655947237a27661acee"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6f1f718cb8020af1403f6428f56623086a756d7517c7ae98ea35512a354cd15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a830e7be2a83e1a56b3733ac2c25a9f2184449e6391140c94d9b916d4c95030"
    sha256 cellar: :any_skip_relocation, monterey:       "d3f288511f85629f6cb8d8b50b2a2c6594bd59c0d7aa403f2e6f8eb7121ef03d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4825915ef5a449a21b10998bbc5e59be7af4f210379c8a5e444b23ef54c0712d"
    sha256 cellar: :any_skip_relocation, catalina:       "458ff336abd3ee99152ffcb535a3f805676ad2ef9f88912ae64ba3ba75634ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "514be853c2c512f28ce394386da5654368496ed9e4ba6c54ee07504af90e237d"
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
