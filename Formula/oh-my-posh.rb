class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.26.2.tar.gz"
  sha256 "585fe15e2687dcb948f7cc46ed07b8ff7b6131222f19bf8b67d75240479140b3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98bab155cb263e3dfb582ddc01e528e7fd5d4ad00a8341cbafa950d79851a956"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55bc5361891ac77a8340e0aa90735fac1b59bc0265948895c40813a6e26beb7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "630c96ea15991c538ec22a147cf9f804bd3eb92aab449a0d809b04834baf263d"
    sha256 cellar: :any_skip_relocation, ventura:        "574a4949893e795fd28f553d9de6045ee069750fe02b95110937e02e0afd7a92"
    sha256 cellar: :any_skip_relocation, monterey:       "fabd95d8e2230b8328bd9fb8736be40f6b2b17ddbc9bade950377022c6952996"
    sha256 cellar: :any_skip_relocation, big_sur:        "36b54f78c4aeb1039939030e6c349a2586e83915e0c4a6b43e6aa4781bada1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb4fb74dd9cc1e7d4e105acffe26d4eec65e383eb515c80284a3bc7afc1cd481"
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

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
