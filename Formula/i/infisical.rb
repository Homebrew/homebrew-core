class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.70.tar.gz"
  sha256 "47e964006225f8985f4dff72fed61ab82ec9744ca8d88d6d8516eb2496eb1b01"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "601abfd2b487cba32d77f9a64dcbbac3c629736463c2bf1647ab90dc0e090372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "601abfd2b487cba32d77f9a64dcbbac3c629736463c2bf1647ab90dc0e090372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "601abfd2b487cba32d77f9a64dcbbac3c629736463c2bf1647ab90dc0e090372"
    sha256 cellar: :any_skip_relocation, sonoma:        "76ef55a5a8f11c03d0cb6db5e1c9aa6b082bdd957d4a646bee7eb05e6adeb263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e288cb138d1afd92e6db397a66e0e7e1785e43d54922d748d5142ef1484dc24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2b37a06a2f5ccc49a6f8a6b9443003c036068c37dfbb8a5034595683c451b65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
