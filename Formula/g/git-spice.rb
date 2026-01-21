class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "6f0a0a342a52e39727ff85d4b0f4bf99b7dd7a65bf698a1f75657fc7b604dc54"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80edc42e66d02e744ee946fa39b83ca4830e5885874e97593a69412c12ba7ddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80edc42e66d02e744ee946fa39b83ca4830e5885874e97593a69412c12ba7ddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80edc42e66d02e744ee946fa39b83ca4830e5885874e97593a69412c12ba7ddf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b97fa716bedcae7bc68b8aeb6252cece74e0f353826f3c5015ecf1d79ad644d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "971841e6757532adcc352728c48ce686a2aa615f0733a4b7f60accdeb7457e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ca0a5999bf87a1c512f701bdddc5b3086cb354113c10ab77abd306605ddeb6e"
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
