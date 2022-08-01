class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.1.2",
      revision: "a60dace71816ac4e38567c1ef766e51cac3b3a20"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc8f872277831e170c31acef76a604e69973116a2f4e2af58c5cbaee334a5db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c18bdc1399a8f3ed08c47f4dd1f9082375912a0bfbd1000c8725e38d4cf90a09"
    sha256 cellar: :any_skip_relocation, monterey:       "c24c5b00f1e412ec3e60c6f9915f5f766578fc9b9b4d991f54668a65a632d966"
    sha256 cellar: :any_skip_relocation, big_sur:        "74aced866c272cc05f1dc600fd558dc208b01b9a5540dc73ef50015573dbe922"
    sha256 cellar: :any_skip_relocation, catalina:       "f291ac799ecf8c113836a8123c108668774742db6b73b1b7d1ed5753cbcf2ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9595399eeaa36fcef0e7b17da6b10d03fda6f7dd06def7a6134b84dee2775797"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    output = Utils.safe_popen_read(bin/"mmctl", "completion", "bash")
    (bash_completion/"mmctl").write output
    output = Utils.safe_popen_read(bin/"mmctl", "completion", "zsh")
    (zsh_completion/"_mmctl").write output
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
