class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://pvetui.org"
  url "https://github.com/devnullvoid/pvetui/releases/download/v1.4.4/pvetui_1.4.4_source.tar.gz"
  sha256 "08e41536f1185d8900de20e74d7c2ca10e92ee6136d8fc1640c4dce816f3d022"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44bba77b81dc0fdb466327c754e90e5d369367608282911cfb10b5e1eb0c28fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44bba77b81dc0fdb466327c754e90e5d369367608282911cfb10b5e1eb0c28fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44bba77b81dc0fdb466327c754e90e5d369367608282911cfb10b5e1eb0c28fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4485f2e101a3139a5a617c9abab8a3867f0ad68a4b3aa81a40653816ac668027"
    sha256 cellar: :any,                 x86_64_linux:      "dd2621848e4f682ef73b726942f2a97a5bf1a686435583f98de7f05c0b3874fd"
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
