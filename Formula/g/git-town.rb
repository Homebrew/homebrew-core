class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v17.2.0.tar.gz"
  sha256 "f547aba92fe464ac0a724def6554c774571a12654234a692ff699c63d6c23620"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "121899148aa40626a761b8851c81f9a18c85c4424b414e2a183b795c5e77a064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "121899148aa40626a761b8851c81f9a18c85c4424b414e2a183b795c5e77a064"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "121899148aa40626a761b8851c81f9a18c85c4424b414e2a183b795c5e77a064"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c3657397249038afcc6af449575b8cdfe0af084aaab041530b17731974bfac"
    sha256 cellar: :any_skip_relocation, ventura:       "f5c3657397249038afcc6af449575b8cdfe0af084aaab041530b17731974bfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5ce705e992ade288de5896b6cb9317661073de767f8d87d48bebf159fc08b30"
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
