class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v10.1.0.tar.gz"
  sha256 "310f03e8e632133a8984126f3bba83cdbe300aef5277d18b4dacf8171e1a74bd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6566a03c32727f27ee256ecb96e08dc35344da0f5fcad3cbdaf6181f6bac842"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54d6f0f7ce22b8d23e1ce67207083b1804bf683ef42ee42781ed974a7c59ee7c"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e406521297903afeb122423d6599e1d1d8094a875a7fc8f436a08242fa3549"
    sha256 cellar: :any_skip_relocation, big_sur:        "27998692ddcccd7e2eb079203cce6275fc0687724d3e16e86c3d4832063e2fae"
    sha256 cellar: :any_skip_relocation, catalina:       "f4e481f520500e549596b7aa98ba7f3d9006a4b5c4378b12b5f445932807df89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8acc048b2df4044fda6b5e185c1cce7f7d26ffb7130c6f38786d6651b0a48087"
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
