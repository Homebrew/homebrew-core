class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v24.1.1.tar.gz"
  sha256 "454665cd678b40e4b7ae89697e6351d900db3454e2de3651f44085a92e9806ad"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "200690d600309d6e9a99947e6c781c48e724b09638ac5b72ccd56589702b2fe5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "200690d600309d6e9a99947e6c781c48e724b09638ac5b72ccd56589702b2fe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "200690d600309d6e9a99947e6c781c48e724b09638ac5b72ccd56589702b2fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfe810a1e6ed3c1605d701ada2876bcd136639f1abba888b70ca57a045962a3b"
    sha256 cellar: :any,                 x86_64_linux:      "e16d9b68c194831df1453c308ac9dc080733f7869759eae0f5aac4112fbc69d9"
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
