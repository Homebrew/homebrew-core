class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v12.0.2.tar.gz"
  sha256 "c53a81b73920172383eb8cfe64b09a8d4e0405a8ccf439c1dcedc8394c585bbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b602296607362b0f51285e0964e3d947cfadb12008baa45b54ff56cdb982975"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e35f6687280551fb1bfa922a8ecc870f13bfbc8c10de5fbcdae37bc3b0c0f8fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e41c34688e1a320781fbb47c8633261e1210e23a0f35b3f9441fbdaecf4785d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd374934308d136121ef98fe455bcc617e5738d32489426e5d3a2a9d207d7c2c"
    sha256 cellar: :any_skip_relocation, ventura:        "7760f3211f2e12fea17db994b5be3ab31dc57f793f775a8b3274f483dea9bd32"
    sha256 cellar: :any_skip_relocation, monterey:       "e7005bed3b3063bb2eed20c9d4665268331c22b4c38d88813803714e13500e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8d329a22f94d20111717c7b071a5f0f9d165a65f60f0352432d69c2e9f9234"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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
