class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.46.2.tar.gz"
  sha256 "31c1c5bda9e169c17403854f728dbf29630c7bf5c08d4f221b4c870f539a0f75"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f264e55176b6f2f8d60cf4c0b0d6654732763d1ba10a786335725eb5872005"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c980e83e9ed9c03f70da6cd032e19c094c961aa69e67b49723c078c42068339e"
    sha256 cellar: :any_skip_relocation, monterey:       "264c4af772d42b6f7b9b3bdb948484816299ea0115680dc13315d03e7a7a54c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3257ff998fb32cf3af3fc3b0048090efdfd7458f15c7b1664188613eec7ae54c"
    sha256 cellar: :any_skip_relocation, catalina:       "26c0cfcbd1c116b0f3bd2c31ec646fb91b4a2184e936aef3c6a71d53dd22302b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e506837754bc592146ca47ab5009aa248ac2dd1fa39e8d58420ca6c7c8a63b8b"
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
