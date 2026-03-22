class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "239be17d3eb05cd9b9630d20bf151c4e12184c1f451a336468e17067c3362ac5"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a072f936507390bb64aa7a9f51d37e8fa3f6a8c70b5afab370f1d886c108f21d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e31be1ecc821c6f666d11b17f04fd65b5eda665f5241eebe729873ec16f677ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc6f01f3eee32294a57e7d722051754df0b1810ba88a80751a00c676b1f3879b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0d7f382100a1d1aa624da878bb71acc509bec18b5cd5250569e8cfd0e43d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c40ca5841e215c3efc3e98f2586436b804a92ea3786aef7e131e70fdabd39ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "881de821567b42067b7bf79e1068d4806441154d2ae54e911423a55321474aa1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
