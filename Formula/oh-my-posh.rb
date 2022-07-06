class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.13.1.tar.gz"
  sha256 "5108a37f2bc079bb5b6ee6afa18daf1b80c8b7bd4ddf34a863ac66fca7030416"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4dc4dcea8608e86cab74f78dfe31f0a157dba18828505aae9dd66e9f2b78164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59a022cc350570409fb0fcaadf11417e3c8f2340cb2dd7f54fc4c12d01a638de"
    sha256 cellar: :any_skip_relocation, monterey:       "82a87134427bb54a8d9190a28c3f2849401c7948fa88b7faa88e8c9c2a17105f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a4c1549b248e9c69c021ea29f9a28c5d32aae07aeec54086fb4bc741868d198"
    sha256 cellar: :any_skip_relocation, catalina:       "5f3c28d345b685ac82cc4935c1fe4002e7d1565472934bb1fc8e736980a4bbcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1df6d217a0ab41945ebced9448e9de09799b6fda2de72d4969f6601d1658650"
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
