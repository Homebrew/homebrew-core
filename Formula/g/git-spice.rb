class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "893b65936a7376d6f241036d1d0b374b4fc81fccf216f3ec7e6a17f064d345e6"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d154d5fbd5e21690e3d773087fa6de97ccba6fce53001259e0575d24aa100ab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d154d5fbd5e21690e3d773087fa6de97ccba6fce53001259e0575d24aa100ab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d154d5fbd5e21690e3d773087fa6de97ccba6fce53001259e0575d24aa100ab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd3a331af4eb9ea86d2afe054c8e924cdf9495a9117568d2378a4d0709d4d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fe96df7ecf638abce20b7e95b91519329826eecb97b51540545a8c4d4955e2"
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
