class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.14.0.tar.gz"
  sha256 "a0dee1b12b23931e0979a200c1aa1b26006ac11e0ab677fd1ae3408a5a0d7489"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea10ccb33c074c420286d82e500286a1276c7988b4d3e2ac0d1df5e47d36c11a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "000c9ceb1077bb9d294d3e5e0a244dd7ba0e2b52243bc7c4b3bb59e0bed6a22f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dbf093356d7bf531edb1939a721c6be6af5b35871586423436049e57b309892"
    sha256 cellar: :any_skip_relocation, monterey:       "3936362316105096c3ad676dc5d34a5351a1dd46da4235f4bae6d81db96e7025"
    sha256 cellar: :any_skip_relocation, big_sur:        "c63256e10676605aaa8d7959a18d70cb261e4fafdc16aeddf055f9f74150519b"
    sha256 cellar: :any_skip_relocation, catalina:       "23a2450f2267abe1a77baada4ea141dbdbc16d768e387396232b0094316f13ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bda6fe56b4d4a493f6c776c16140c901b0914c9012004e5d132a63279f197eac"
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
