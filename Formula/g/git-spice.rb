class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "93b301b39417fdf306796809378256cf6d150d82867910ee22445ae68f80fe64"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7797020332e6cea593463ec5efe0e1351cccf0ccedb1be5cec1855ad2eafbb27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7797020332e6cea593463ec5efe0e1351cccf0ccedb1be5cec1855ad2eafbb27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7797020332e6cea593463ec5efe0e1351cccf0ccedb1be5cec1855ad2eafbb27"
    sha256 cellar: :any_skip_relocation, sonoma:        "715f32114dd6d68bf360ff605fc3233340b13d6c00a0ae419edd012aa4a35228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d57118af1ad5abb4ddab205bb5e33b7e719f51e608ec314408cf18bc41515b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69878fe046687637eea82c8e61c0bca237b5ffc521265773a30027c3ec9a15a"
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
