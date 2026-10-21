class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "5a7a20433c830b290f974b58fb3c7b800a3369f7ba8a2dab6c3861f0a823da5f"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11b5416b83a28f982fc5cd79698d9c7dc502766d0f6879f145417e1046b55c4b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11b5416b83a28f982fc5cd79698d9c7dc502766d0f6879f145417e1046b55c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11b5416b83a28f982fc5cd79698d9c7dc502766d0f6879f145417e1046b55c4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37c23ad17b8c16b30fcf2b50c046732af050837b19169ed5b42925aff587dbdd"
    sha256 cellar: :any,                 x86_64_linux:      "14b49a76545301cbfeec45f4d47e7b58b57ee2a358416eace22ee60562496d9c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main._version=#{version}"
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
