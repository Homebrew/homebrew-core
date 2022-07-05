class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.11.2.tar.gz"
  sha256 "2325e1ff5e00a180e75c3d52ce73e306f4955bf1471f4a9e7d4ac5f3fed7e842"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83ee4f3d0e0da703958a00dd0c7ab9ac8bd3396cb07cf31b997bd19908d18caf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1584ec23f70ef5a32392e3c287fb3f9678c20c097ee21755dcf4290825e28f"
    sha256 cellar: :any_skip_relocation, monterey:       "22257f685b209573e5f93b42aeb536b04059f89c9e3bc2dc8b874c3bd54422da"
    sha256 cellar: :any_skip_relocation, big_sur:        "990c6c954e734c79a1513a59284fe16bae18bb854d82f8bc222dc7f60a00c8f5"
    sha256 cellar: :any_skip_relocation, catalina:       "441fa21eaf0b71ba1840aeb7b8b78647923b0203e2af3af2522f1076bd307576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a27641b8506c2e65cabd21531b4ecc94e9119a854c335772b0d318251d62dfd"
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
