class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "d03e4d1909ebc2b2c0ab4fb3cfb6248c8209de55eab4f2f564708f9cbd013b8e"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3962cd71cccfbcf207a34e553b8b996e4c4690344d62ae5fe88e3820eab9a0b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3962cd71cccfbcf207a34e553b8b996e4c4690344d62ae5fe88e3820eab9a0b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3962cd71cccfbcf207a34e553b8b996e4c4690344d62ae5fe88e3820eab9a0b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c102a8959d74358807163645acf5771a7617406da2b2673429cee0fe96801a50"
    sha256 cellar: :any_skip_relocation, ventura:       "c102a8959d74358807163645acf5771a7617406da2b2673429cee0fe96801a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a88d424b787b4b0e9c48c5aec8c0a340b2eb3e53ad026ea6217405210c08ed5d"
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
