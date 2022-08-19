class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.32.3.tar.gz"
  sha256 "c6a66385b38acb378ac63181e4db51f7338bce533b481be2eea6ca7c09834677"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0b31cfbf38404055cf2cc02281c8b446cbd710bfaa6fdbf93e8247df42b3f5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78e6e0e2fcb2025b9a710176870002cc42a97b4d3c448c55e54f492763ab378c"
    sha256 cellar: :any_skip_relocation, monterey:       "7942115821cbed680a446ebeffab2634c6c86c7a62b85a78ae250d63be6b98ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5faef6c4298581dc1d5fac34d3b932f32bb7d5696a8cf9479693ebe6379a66d"
    sha256 cellar: :any_skip_relocation, catalina:       "ebd1d61bdf578aedaecda65b2f1d2e079f38eb8f608dce32fc27b9c660f56a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93060418b9d1beb7e21cdd20a568388ed10f9bbcda4c1892b8c5343c0dcb828"
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
