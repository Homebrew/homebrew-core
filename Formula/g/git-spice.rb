class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "41c51171bab262341764efe2d0a24f493f67bf16132433ce81d13e2b1623cb74"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ac6aadf0375449a3599dc32e1aa63d4c6c011427f231b4acff1968769c4e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ac6aadf0375449a3599dc32e1aa63d4c6c011427f231b4acff1968769c4e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ac6aadf0375449a3599dc32e1aa63d4c6c011427f231b4acff1968769c4e1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0989f418a42754277b9edaa42066657edd82d5ff0eb4794694ec65e500437a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77730694f5377baf7297026019c94e8e29b6453e77d45d3a19f3da07a6857715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5151c0342fd441993696736f5310ab35f164ea1a06b541dee0e8ae49b1ba692"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gs")

    generate_completions_from_executable(bin/"gs", "shell", "completion")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/gs log long 2>&1")

    output = shell_output("#{bin}/gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/gs --version")
  end
end
