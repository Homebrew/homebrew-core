class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v22.0.0.tar.gz"
  sha256 "4ba0282fdcc0a4e67240eebc620b6304cd94f551a0f846f0becb8284c81165b9"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c88efb56501ada3e9a06aa5688eba4ff5378c9eac4329dea5a048a2550f3fa41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c88efb56501ada3e9a06aa5688eba4ff5378c9eac4329dea5a048a2550f3fa41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88efb56501ada3e9a06aa5688eba4ff5378c9eac4329dea5a048a2550f3fa41"
    sha256 cellar: :any_skip_relocation, sonoma:        "33f9b652bd4a1660ce082cd210cd58f085c7e36db28ee547cdad58927d526118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab4f5d36ed387ce66dafb623b19f6f8dc2802ea693feed8cc2df0b16cb2dafc"
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
