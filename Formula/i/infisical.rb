class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.42.6.tar.gz"
  sha256 "4a495f151d34237ed5c3f7d3632e101b638ee7186c445beba2724c2f8345c4ff"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76a75926f635f14332a7ec1489b426c9b6f539e21956c5581aed2bdec9fbbf08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76a75926f635f14332a7ec1489b426c9b6f539e21956c5581aed2bdec9fbbf08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a75926f635f14332a7ec1489b426c9b6f539e21956c5581aed2bdec9fbbf08"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e05ae51a6e5696b156da5c1c6547048e12e2758e646fc1e681858ece7d38cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ce151888773c923a142c87886a3e2d87ed498424fb0874ceca2faef38a92ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
