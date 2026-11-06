class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v24.1.1.tar.gz"
  sha256 "454665cd678b40e4b7ae89697e6351d900db3454e2de3651f44085a92e9806ad"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c549c571f99135a6418e3947a645b810aec3a27f5e38f5bfef6c1964f70584ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c549c571f99135a6418e3947a645b810aec3a27f5e38f5bfef6c1964f70584ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c549c571f99135a6418e3947a645b810aec3a27f5e38f5bfef6c1964f70584ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a570aee07b17dcc3f77d9eaaf8487fcb47f98cc76b9cdc0c3c3d4be2866f26eb"
    sha256 cellar: :any,                 x86_64_linux:      "6178ff35298749767fa5a994332e89cca81b4c7fbff040e27e00efb6412c04b8"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = %W[
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
