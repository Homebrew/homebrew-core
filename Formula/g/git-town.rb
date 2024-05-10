class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v14.2.0.tar.gz"
  sha256 "8984afe372bf9b75411c653779db7d516517e9fd59f609c2a7de8c534e0538a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c75cf7da47c8a6518ecd239dc99926a0f3af2af44ed0e66da65c97154ae5bcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd25d96736ecab03bf19bff2afb895bf33d475526e91b0e59fae3dbc35d96f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "245cba6176ac1985fbe835f4671ead8df638d17526da9ac3a43b588331148d83"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e2e3849e0f80afabbee90e4c94fcf529ea6a626a8942518774ebdb96e04465a"
    sha256 cellar: :any_skip_relocation, ventura:        "279b483713f4d897d2a3a4c2a7eccaae8f637784d723f4b4120bb9b11d83cfae"
    sha256 cellar: :any_skip_relocation, monterey:       "7c662fee30a8a23bb98fe3cf924cdebc9d7aa4c3825566b1037034768413e97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38259fc26995dd880ede7a65afc9567d9ba5de83d5fa64efc5961cc7483c3418"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
