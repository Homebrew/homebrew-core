class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.0.0.tar.gz"
  sha256 "4e9faaed91297d12888a76b4713de92997b0600f23fc965f9db38e810c4cf651"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "734d0befcc9727537420a3371f6a5625c6c6d539e17533536da5a455bc8f11c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c301b2ca1d11838cc348dafa21c8a42bc6641e1e9219e2a7b37224abcf564b40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21139f884fbdc0b11db17517483af8821bba181c599279b936bf13a0ca591372"
    sha256 cellar: :any_skip_relocation, ventura:        "fb3391cfb0ae4db6cdd095a8476c8d24b744664fae769375007ebed4733b1d55"
    sha256 cellar: :any_skip_relocation, monterey:       "f4e65a5ea9c077d680a3ba0c93189c39ffc55b73ef82237f2577d1c2ed635407"
    sha256 cellar: :any_skip_relocation, big_sur:        "3df2a08bea00b1a32f8f16cfaf1cac69b11a6e541a32716629b99ee1d2d99e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240de63857c043238882bb7e55aac7dbb8f79e746284a9597493c2a9adac2b3b"
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
