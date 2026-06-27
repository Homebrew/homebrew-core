class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "1e48262567f9a88703aaa8f60e31493cfb0feec36da4e0c9b06913cd5b9cd995"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b6ae3ee9aed3906c5f570b821461f9948fb3d6d1eb8b1865c512ec52bdb0880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b6ae3ee9aed3906c5f570b821461f9948fb3d6d1eb8b1865c512ec52bdb0880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b6ae3ee9aed3906c5f570b821461f9948fb3d6d1eb8b1865c512ec52bdb0880"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96fef41aef0391098304a33cd7e144d6e8322985bb189ffd2d86f53c1b4e112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac3774210047de3c6f9a9a139b597c2943670cb47b5e647073649cfa115b3d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef36df70d251cde7df5eb27f79e8e45645bf96482a194e73bfd8e32a6005648"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-spice")

    generate_completions_from_executable(bin/"git-spice", "shell", "completion")
  end

  def caveats
    <<~EOS
      The 'gs' executable has been renamed to 'git-spice'.
      If you prefer to use 'gs', add an alias to your shell configuration:

        alias gs='git-spice'
    EOS
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/git-spice log long 2>&1")

    output = shell_output("#{bin}/git-spice branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/git-spice --version")
  end
end
