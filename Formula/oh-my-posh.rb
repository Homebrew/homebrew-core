class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.3.1.tar.gz"
  sha256 "97307ca0834223ec88852244f67f74082541190ed0b45c254d4bcf98cc8c2346"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5918c60e5e1c809de7464d37fd6b8e452797cae855e4616a813461fcad0f86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cc530f3c0948c2cd62f035aee10d893f69a9453efac3fda62fc83e0d4a361cd"
    sha256 cellar: :any_skip_relocation, monterey:       "1271652e03b952bc3fd32aa0d96772f93cc03b378e155a76daedc3ed8e5a82c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "da71dba1f07667fb14ce5b8e41ecbe264f121dc6c061ccefc4e4f42aa865f289"
    sha256 cellar: :any_skip_relocation, catalina:       "4b1dcc847ecc3578362286ceca6dd64c4723ffa74a246c5d3247bace60a2201d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6343d2f6037b4d41197d1d033110fa508a7a5f459f5beca136c1750dc621ae8"
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
