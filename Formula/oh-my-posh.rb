class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.36.4.tar.gz"
  sha256 "ea8b4b2e0a4f19063f5f7d4b26c0e56fc876290e42adbc284e84154d12a58881"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e84d98356d41806ebaebcd227c220191d242bfd3e8a434993e1a782ccaf24182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6b3c10b2e8a6e328beea39d2d5061e9154590b176b2299d8c8d18456ebfa070"
    sha256 cellar: :any_skip_relocation, monterey:       "1e0b46bbee86f84f7c8a957f413334cdf7b7a6e61b47143364189656e4fee939"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b96cbcb9ac6f805434767d6d502c62b8cf80252968e8bbe1b354a1f0fbe4f31"
    sha256 cellar: :any_skip_relocation, catalina:       "02cfda544e030405d87364ca8102c6392a24e2e8a21894ce02a15308559344eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d502c3ce7e2a8a65c00daa67fcac781f89a232da2ff8445d18c4f654236528ef"
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
