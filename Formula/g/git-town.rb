class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v24.2.0.tar.gz"
  sha256 "592e067a54712b36c5eac50af2cf8aa6d4030359f5fad3b16fe5779e0eed1aeb"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e8d0c08cc73bd1e8d3a2ce41237539c6e21df8ad691a4223882a3c45ad75c25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e8d0c08cc73bd1e8d3a2ce41237539c6e21df8ad691a4223882a3c45ad75c25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e8d0c08cc73bd1e8d3a2ce41237539c6e21df8ad691a4223882a3c45ad75c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "44328408cfde092498c7265e7c40d447a334d5787d0ff1d5e8134c59428700ef"
    sha256 cellar: :any,                 x86_64_linux:      "81bfc303cc61b342a0a0449e647854b93f779fbbea9f6d599eb7e603809350d8"
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
