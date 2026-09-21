class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "e0cc5e1ef00a9bcca76664da18b3dfd93c5173f996464032a6133c6fbde40600"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50264d8ab43e5aaf590fb63701f862f8a44f820de797b8ddaf04bf7780e9f631"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2dab06470024c5ff0fcf810cc68b9336f5c33eb6fd7d4a931c27f33dec4c70f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e69eb7e2bc3bc1f9287ef09aca340470ab7d02a1078637946c4bbc4a133a5b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b72e3973dcc8b8bbc5988572dec0f7cbc25198645f5696af1378bf354d61b9fd"
    sha256 cellar: :any_skip_relocation, sonoma:            "af4a456109bf199fcfe4a2f718e805f6efd01deca1eb6eb40b3dd62cd31e1eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f060bd96164bb43191b075fdadf325192929dac28d56674d98a268522f1e7ac0"
    sha256 cellar: :any,                 x86_64_linux:      "f0952e73a7802a2eb7114237bbc140755bc6606c4e66b9cfa6edbc9eef930467"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end
