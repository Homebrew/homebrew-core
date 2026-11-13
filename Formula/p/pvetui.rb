class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://pvetui.org"
  url "https://github.com/devnullvoid/pvetui/releases/download/v1.4.5/pvetui_1.4.5_source.tar.gz"
  sha256 "1cd5ead5cb9f2ed1177044cef7e22f7766f393e6f02adc0f19d841d62e546709"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "edbe5f7a77e16aa0b1e949f12619ecd2a5747e5bba5b2909641357cf55ed62fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edbe5f7a77e16aa0b1e949f12619ecd2a5747e5bba5b2909641357cf55ed62fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edbe5f7a77e16aa0b1e949f12619ecd2a5747e5bba5b2909641357cf55ed62fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "717457072516be9a79ffff251e9961321811a4b034ec40044c4f902b46f54120"
    sha256 cellar: :any,                 x86_64_linux:      "52874e7acb571eb75e16df94ae126a1e7ebdf63a45894327208162a0c73dc8ba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
