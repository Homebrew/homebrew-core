class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.1.0.tar.gz"
  sha256 "0da13d03ad34efc2816e5835f8052630f27c8d681b933c9a7133f4425da7ecc9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2e08a76f0701abaa2a24b9743c04aa860843a914ba4875137a69768ebc40f55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b376a3ba94214d85192f4f1916bf6a65bca0afc7bba47755b469afaaccd294"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1185e082ab9cd95302cbdb14518d392fbecaf1bbbd86d9465825438fb97cd185"
    sha256 cellar: :any_skip_relocation, ventura:        "435f7d90c111df5fe9e863eb03153db08128e8c6a75e78ca6b881b7332ae709e"
    sha256 cellar: :any_skip_relocation, monterey:       "8b8b1e907c7323297a37f2994f4fb4d17f0c2dc5e1d0462246dcacfc81e73f09"
    sha256 cellar: :any_skip_relocation, big_sur:        "492e64d6999be92ceed061b245a761991e453d4de7c35d768ab2c23a6bdba5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "710b247404d1f39ac967a7caa1697cada897b4eaa7b6cbc9f061cf29621a94fa"
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
