class IprouteMac < Formula
  desc "Native Go implementation of Linux iproute2 (ip, bridge, ss) for macOS"
  homepage "https://github.com/rgcr/iproute-mac"
  url "https://github.com/rgcr/iproute-mac/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b12f50765d07a903c8b569d0ea787a4b8b0254437499a37ebfaa84827d068953"
  license "MIT"
  head "https://github.com/rgcr/iproute-mac.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  conflicts_with "iproute2mac", because: "both install `ip`, `bridge` and `ss` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/rgcr/iproute-mac/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ip"), "./cmd/ip"
    system "go", "build", *std_go_args(ldflags:, output: bin/"bridge"), "./cmd/bridge"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ss"), "./cmd/ss"

    generate_completions_from_executable(bin/"ip", "completion", shell_parameter_format: :cobra)
    generate_completions_from_executable(bin/"bridge", "completion", shell_parameter_format: :cobra)
    generate_completions_from_executable(bin/"ss", "completion", shell_parameter_format: :cobra)

    man8.install "docs/man/ip.8"
    man8.install "docs/man/bridge.8"
    man8.install "docs/man/ss.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ip --version")
    assert_match "LOOPBACK", shell_output("#{bin}/ip link show lo0")
    assert_match "bridge", shell_output("#{bin}/bridge --help 2>&1")
    system bin/"ss"
  end
end
