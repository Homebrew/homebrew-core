class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.64.1.tar.gz"
  sha256 "49ec9a365ebfa807451c2cde15c246ae9e1ba254a1ea1d64f19d452017a89289"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b663160b2e9dab4aec80163321ed77eccabb87edb6b8a3026e3f7aea55c9e32d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d26a935eaec54ceff64328190ffd7088a2d44385ec2de11ab3884d62e0c350b"
    sha256 cellar: :any_skip_relocation, monterey:       "8c2488bfe112576d0b177ec2c04635318554324470aebf6992ada56ecdb4a1de"
    sha256 cellar: :any_skip_relocation, big_sur:        "08b665155f3f962a872897f323fdad75a7a5a922bf21c0f69c5bfd134749f352"
    sha256 cellar: :any_skip_relocation, catalina:       "677329cb23d2fc1fbb7bdd7b6df7f23fe610a55b9ca659d64eabaececfb204c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89bb38fc8086a19d36c048024f118e8aad59b816db67e6f929db6438b225ea69"
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
