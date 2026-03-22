class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "71c2547ec091fec2fa481a36d64114dff767a80503dbbfb49b94bae41fafd496"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bad3091ff64b14a85e1cb2e2009a63e52e3dd048fa17325ea8467467a2ea243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e65dd7657534c820928935f70ca48238ab97fcbb2807661f98115a69ed9a92fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e828cb0555e5bf11fb85df4466703de215c9c07e62a3a2063308e74b6d0c3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0abf051719a2d28229b843a07d485b784b1b228c3c1c97cd566ead38565926fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934b9872ee56dfaa26efd4f3d7353047023f226fa337a90f3af281640a594967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84099d8090c65abb09415a06268f76a3852cf02aec83a1a3b99c64f8d0934ddd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
