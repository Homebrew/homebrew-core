class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.59.0.tar.gz"
  sha256 "055d29652992cf9d529016d24396d527ee2e9003e3310a51741bdb07c5ac29c1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bc5c614082efc5a22718f739aeef08366b2f27ef66506722008272bbb8ebbc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "042bad99c418c6a07ecd81c6a7cd26503ed3095b25ad793796fcfbf1b7598c7c"
    sha256 cellar: :any_skip_relocation, monterey:       "36d90123c7b248174255cf6832cf547748e0bb17ea210ac30a45612055d03e2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "179ad310fbd021ed63186bc9cdeb7b532059312b2fd8721d360a21a80f7f4d58"
    sha256 cellar: :any_skip_relocation, catalina:       "2176b88c50f9d9b5ff2e1eed777d869441d896935f9916e7d6f8bf2e14cbe343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "528bc083b8414717dce207f7a9528f864d7d56704644e17a8f37bd2cb0871352"
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
