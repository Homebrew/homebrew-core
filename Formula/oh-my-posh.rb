class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.78.0.tar.gz"
  sha256 "172b255648d3e93ebaaccec3bb9ddb4c9974fcfe10e32e713d303ec478dd7642"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42882c4fb1ffca4cb1ec603216d7c0e3383a5532090d3f87f4fc626c37fcf755"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63c4e8dbb5a2d5e3357d94062c470092cf0cf6a574e383a6684ff1a294705ee6"
    sha256 cellar: :any_skip_relocation, monterey:       "db62ab7c8a6c5cb7096548332a568887c330eeb5313e0e25f58b530443e53c2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ddb2f64050f88b0c1c1b47a5d8bdf3f62ad0ed792e0f782895d83e3cce9cc89"
    sha256 cellar: :any_skip_relocation, catalina:       "f8b7840c8478a5f83be943178be8721a485a46a77520c0aba0cce2c57f0fabcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f7890a522d9f26264a5b94f2c8bd0098cb771d7b5b627b55b325cf97b4d8ec"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
