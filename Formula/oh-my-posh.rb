class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.85.1.tar.gz"
  sha256 "b4bf40c31412defeb0e93430bd889d128b8dd56833d23163fc969a78abfab9da"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fb4e1980f4c9f3b69bb1fbba1dc1372de0e1e477b579e5a35d2da4bcef70b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04920fc23dc4bb941bfca1e4dca93d3fbf531ae3b44c8f91dec05039175a96da"
    sha256 cellar: :any_skip_relocation, monterey:       "b634d9e45c3fb4e1c1bcf6f5cfcbfb1bb08994e866c980c5e5a899e5645c7d30"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1fe8109672e163ed7bea9b63aec9b8d02bd6cd3562fa209cc13f8eb4ba4bb39"
    sha256 cellar: :any_skip_relocation, catalina:       "a4942c154f9212335da9cd7544de3d1ff169c8fbf838f83c17c07b858562d7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1344f81d2520b7ed6c180b77dc20ce6f63829106fee9b0091ee0aa82741a7440"
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
