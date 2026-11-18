class Mob < Formula
  desc "Tool for smooth Git handover in mob programming sessions"
  homepage "https://mob.sh"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/v5.4.4.tar.gz"
  sha256 "1a55de8b278885b57347e3cadcb498b5d24b83f6e8299d867782294586b6b91a"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df5a204f29366a4521a640a1328cb0d00873a02511ae0d5e2f4d8682a67e3f62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df5a204f29366a4521a640a1328cb0d00873a02511ae0d5e2f4d8682a67e3f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df5a204f29366a4521a640a1328cb0d00873a02511ae0d5e2f4d8682a67e3f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d23921b8abc5e834612dd1461b64a9120bd610a9783121b4e202bccc024f1272"
    sha256 cellar: :any,                 x86_64_linux:      "67b8ee7a0f1fba2e60e7311789b708eb1daaf191c81f5df9ce95722c4c21d7d6"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mob version")
    assert_match "MOB_CLI_NAME=\"mob\"", shell_output("#{bin}/mob config")
  end
end
