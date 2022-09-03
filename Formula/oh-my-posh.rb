class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.37.1.tar.gz"
  sha256 "a1f498f538c0d434989256f3543065d8b0168f2775702c1f693ff9ebdcd00bde"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43147e35d0f68f16c4ac5d227b28f0d938e1cbd5b90b5c16a93d494c4c0e00bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "883cae6028e6d66109fb1c2e58ab87fe00ef5879f254a9090496bd452c511fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "3571f09e042064ed2e0d113a08972899bb5986ab43db05717e891437b40e2fc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b8402aa1f2979d182325f861bdac8257af68b5e1a51d0a63abb41407f5a10d5"
    sha256 cellar: :any_skip_relocation, catalina:       "15e2e6e86317f67303797190d40a5fa0ea1bd6b4b1e4206c1a03460e87d90e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a792d472287cd1e65926583e538ca0c3243d3c386a167c26c7c5145af450889a"
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
