class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "b00cc82627ae71cdba3890db2179b19a563f26d24d0ed9ee41de18cace3d3d67"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "def49fe7ab835c9fd1bbc824506aaa54abdc63168adf53211791de305ca872bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "def49fe7ab835c9fd1bbc824506aaa54abdc63168adf53211791de305ca872bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "def49fe7ab835c9fd1bbc824506aaa54abdc63168adf53211791de305ca872bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a282776698b38e4930cab5ea78a2c220a56fb88d8b1eebcab7b1347c3719a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb6285210f5f96af385825ea0a8bf22875f53db87b4d30c5c1a78ecebd7a2793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0668db23c53abd23e638e3b1e3c35a434c24cf1c06082e29a312764d6145ac85"
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
