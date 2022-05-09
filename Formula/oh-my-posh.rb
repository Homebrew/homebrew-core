class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.80.1.tar.gz"
  sha256 "025631cc54fed2f74dcf900bffe9a4bbe1b1aa9d9957f8275aecb2cd07fef71f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f2c6169c7692d2d9ac20983ce4a2909593fc39b8e6bf04f08ce09746ad3e71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cff5e9415f5c50525fa58d4598bee03465419984ba4d3c04b7bbbcb39fdad73b"
    sha256 cellar: :any_skip_relocation, monterey:       "d24b8482fba6aef3a49484037dcef2a2921c927bfa28730659f5bda9a640b7ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "50b6629a4abd8b0e1cbb2a5a66177e315dcb3f288b09b78ab579982f17f9f2ae"
    sha256 cellar: :any_skip_relocation, catalina:       "6a35a825ebc3069614c8ba13a44aa0783f98640ba33f04dc65457b66b34f3ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cade5c9f646146283004919db2ce86aa5cc1fe6c9457a4a6c34fe01a8a615d9a"
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
