class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "22f1e875fd5da1683b20815c3ebc7da07bbba1b5b37528396cf065880f681268"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a087f42b47275314a7b55af7c0918ced5d49511772358f0af44ed66da555fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a087f42b47275314a7b55af7c0918ced5d49511772358f0af44ed66da555fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60a087f42b47275314a7b55af7c0918ced5d49511772358f0af44ed66da555fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1524a4d2775a1102dc30ca2bfcce3f74f291c8189b33d360bebc526215626927"
    sha256 cellar: :any_skip_relocation, ventura:       "1524a4d2775a1102dc30ca2bfcce3f74f291c8189b33d360bebc526215626927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c885be077e9ba0c769efd9daef6be6c51cd2bc00f53be5fd7d3dc1e141fd22"
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
