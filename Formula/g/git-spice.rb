class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "c8798b624064c2f32542f102a59ba4eaf95b1a3cb95a1205b0791d66e00778b7"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb9077aa145da8c212de3ca4d48c52a6cba6e1914625d0c80a73b135fc75ffb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9077aa145da8c212de3ca4d48c52a6cba6e1914625d0c80a73b135fc75ffb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb9077aa145da8c212de3ca4d48c52a6cba6e1914625d0c80a73b135fc75ffb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0584abd93c4bc4d08f0ba743c54052775c93bcc158c50738902a890af8454a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c279799389ae87c74ebecd06677cf85855bcb5d2ce1c45e4632859cbe089756"
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
