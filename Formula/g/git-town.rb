class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v23.0.3.tar.gz"
  sha256 "3f4382106bfa438b096af829789092bd604477e239cbd626066acc490eff47ba"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "883c21f9c9c38fcee23757aef59424ce3f521f8e785d5c3ea21cc4c895805b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883c21f9c9c38fcee23757aef59424ce3f521f8e785d5c3ea21cc4c895805b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "883c21f9c9c38fcee23757aef59424ce3f521f8e785d5c3ea21cc4c895805b0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "16a572d940f553b0307bcebee5be396c9ce53091468f751d8de214a129d13791"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88533cf40dd7479bf1d59a61fcc0b8d38b78335fc2fecc88e15870cd72924b67"
    sha256 cellar: :any,                 x86_64_linux:  "d6390ddfb03e2963b2d3c068b7b6706b2ec0f4b2a3beb889393c1a9e0094624d"
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
