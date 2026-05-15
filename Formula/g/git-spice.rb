class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "4837b84e6f8766735ef20b807ccadd2cab92cb008fabcd3c1c6b950cdc2926cd"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e53e4fef493b501afb04b8d565d2385a71af50a38d179a6a1c4967a307406e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53e4fef493b501afb04b8d565d2385a71af50a38d179a6a1c4967a307406e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53e4fef493b501afb04b8d565d2385a71af50a38d179a6a1c4967a307406e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "0285f85c6cf490d9bc887cc3db119a86ccf43d24d628e45a6c3d129cf8828361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b2544429bd746fa2e3aab85190765ece55adb46443f0a5f0dc1bb1738f1f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d15371cab05aa9b9a4e7ad324fdcd9c649433c0006802f482f9d749069bd710"
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
