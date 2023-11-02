class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v10.0.0.tar.gz"
  sha256 "7a5abc1095b974d5f2d44e920c48720c10b3ab398996091d67d2b8ae60a694b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "699e1bd8d7a536ce5552706d1c6b5ac51ea806f4b680b44a0beca2131554c73f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e29fc23dec0bb31d73abde35a80134680512d40bf0d9e7c66a783854337c690e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e137e911403286d529fb198f7c44734c8b957221db6c53c3b1846ff96e8f702"
    sha256 cellar: :any_skip_relocation, sonoma:         "17f4df4e993f2b1dadd25d9fb12c48614b7f55b4d361a0e0278374389ed4f234"
    sha256 cellar: :any_skip_relocation, ventura:        "774c1b2b19945df082638a883fddff583a631e4f92d0cc2fcb83c1501cf7f788"
    sha256 cellar: :any_skip_relocation, monterey:       "d047727a21e48f9aaad1bd1c8d023bac7d10a2f46026de49b9b22a37f0e31655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461292814b2650a572d7b2c811b1b50ace62a9a5f2753b6fe08abb159fbb94ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v10/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v10/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
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
