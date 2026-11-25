class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "1cb6ddacbcd0ed22c748facd41766fb71f720ff3211c19d2449f43f43419e3c6"
  license "MIT"

  bottle do
    manifest_sha256 "dc46ec775ca1bcf6bfa2a4283d1ccf2f09ac7af348f5a30b6e07dca6fe70a090"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc4fa02a3d7204f999c1716c004355df5c4371115062878482e0c02fc53b01bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc4fa02a3d7204f999c1716c004355df5c4371115062878482e0c02fc53b01bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc4fa02a3d7204f999c1716c004355df5c4371115062878482e0c02fc53b01bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34b3ac1b955cc2bbcc85948f3d95fb78c2d2adbd93f82ba43c5492a0a409cea5"
    sha256 cellar: :any,                 x86_64_linux:      "5c74d6559c9f9c18ab72d01b2d9a60ac972d7a40ccdd8658ee2a7f24aa018c7d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Dicklesworthstone/beads_viewer/pkg/version.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
    generate_completions_from_executable(bin/"bv", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
