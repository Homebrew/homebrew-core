class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.33.0.tar.gz"
  sha256 "a99445f6fe5a53e64c626fd2e80e9b9836716af48b42e05a309915a3d23ab667"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41301bece8ca8f6d25a79b79fc0d19534f4c02f166ed99d90cbaa5f5b64fd37b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cac22aa34841cdd4b41ae51757f46151f44b49a10504b7b25c55bbbac93034b"
    sha256 cellar: :any_skip_relocation, monterey:       "baa8ba501de37170d80388794cf4e24ab897e381e572b4e92293d17da0e0ff0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfd028220437785c68f11e13fa76ebd8da1b794434905da59f97ef2c2a13f2de"
    sha256 cellar: :any_skip_relocation, catalina:       "148467813acfed3fee9dcbde5a76ef6ae818e5f07e754ac495085eabfb3baa21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f4b8b72530cbfdea13d7dcc46fce6fb193b342642ea6c8f9f57a5bb5099083"
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
