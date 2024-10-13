class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://github.com/abhinav/git-spice"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cfef3ebaaf750d83ae9480663f256c611a9abffd2fd6af95398187313e11fa1e"
  license all_of: [
    "GPL-3.0-or-later",
    "BSD-3-Clause", # internal/komplete/{komplete.go, komplete_test.go}
  ]
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca908bb6e964f706c4e369f76c8a28566a70524532ce202bf35c847f561211e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca908bb6e964f706c4e369f76c8a28566a70524532ce202bf35c847f561211e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca908bb6e964f706c4e369f76c8a28566a70524532ce202bf35c847f561211e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e082872f5301e821398a345a35d47921baf1146326e1d9d11c4c0e344d3b49d"
    sha256 cellar: :any_skip_relocation, ventura:       "2e082872f5301e821398a345a35d47921baf1146326e1d9d11c4c0e344d3b49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e13a55d1031914733756c2f9779a04de4f2f2052b0f0175fce2e6b6ec61862a"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gs")

    generate_completions_from_executable(bin/"gs", "shell", "completion", base_name: "gs")
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
