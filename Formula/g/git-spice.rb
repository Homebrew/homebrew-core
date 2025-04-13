class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "723ebd25d836c4c6577e5b73f37ed33ac39f6e9217108931a8bb68f1ae7766ac"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dea16b2c4ef28e35e3c4897bdc1a84746b589c3faac7a56c832b04cd418a266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dea16b2c4ef28e35e3c4897bdc1a84746b589c3faac7a56c832b04cd418a266"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dea16b2c4ef28e35e3c4897bdc1a84746b589c3faac7a56c832b04cd418a266"
    sha256 cellar: :any_skip_relocation, sonoma:        "280dbe5e3e836aabd8124159cd44ec5d6d413b7dbb72a0905805c988d5b8bf43"
    sha256 cellar: :any_skip_relocation, ventura:       "280dbe5e3e836aabd8124159cd44ec5d6d413b7dbb72a0905805c988d5b8bf43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d920adf676158084b03bddc80d1c5a4ad7b32feeac9c03c9ca68a6b5ee2d04d4"
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
