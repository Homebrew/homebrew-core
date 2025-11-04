class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "41c51171bab262341764efe2d0a24f493f67bf16132433ce81d13e2b1623cb74"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3248c72a01ee1bc9eefda2b92d050948a4bc0c0f3a59dc577e71f485bc8a7491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3248c72a01ee1bc9eefda2b92d050948a4bc0c0f3a59dc577e71f485bc8a7491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3248c72a01ee1bc9eefda2b92d050948a4bc0c0f3a59dc577e71f485bc8a7491"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b55b3b6cfece49bca5802b754772f226d8d81b043c74b507db309e48ca7cf24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c53ce0421b69f773168751464eaad6d3652597f956b5df7db5b1a9069ff9f31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e60a42dad76401a722218951569303fd30c8f98884cb3b349f0c97df77f81149"
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
