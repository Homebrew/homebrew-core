class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "48227f33d83c02f9b688eb965e8c7d8c1718a89545d7b3a1ee4968112357e718"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb9a31deee34b765e919ed262f53d50271c19b5212e5add1a3ddb087b9723079"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49a4a2547c941c6b5a8308134aa3703845698ad72bc9e16f2c4712d8ad328522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b7612ed30905492a2622f4c0de8eccd0806ad2cd65c2009a695031e231d546f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4dc20633fb4a183ae62dd4e47817481b2ec8aa03c8a7db73b16489a44bccdef"
    sha256 cellar: :any,                 x86_64_linux:      "26d0cd0c758dcf553a5275807779df9b656fe31b0f117f036ac6545eb294820a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/outscale/octl/pkg/version.Version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "homebrew")

    generate_completions_from_executable(bin/"octl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octl --version")

    assert_match "One CLI to rule them all", shell_output("#{bin}/octl 2>&1")

    config = testpath/"config.json"
    system bin/"octl", "profile", "add", "brew-test",
           "--ak", "AKIADUMMY", "--sk", "SKDUMMY", "--region", "eu-west-2", "--config", config
    assert_match "eu-west-2", shell_output("#{bin}/octl profile list --config #{config}")
  end
end
