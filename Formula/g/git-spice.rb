class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "a14e45062a068aba6228dabaa94ffcd907ec522587d1ca2222a391d3cd545705"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "731c4a4fd9d507881ae09d1296622da18a199f9c94b1ad61a43a5b937f7032cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "731c4a4fd9d507881ae09d1296622da18a199f9c94b1ad61a43a5b937f7032cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "731c4a4fd9d507881ae09d1296622da18a199f9c94b1ad61a43a5b937f7032cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4509faf1f4cb04ef626471e88a5d25e21dcdde9dddd563ffb6cbe0934b87d32"
    sha256 cellar: :any,                 x86_64_linux:      "3742536a1d6b6e0d487a590a919a47cdcdb46dcfdd719e6703a263bf6cc2dc2b"
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
