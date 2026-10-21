class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "050823ea0aa7bcc14a31f090ffb79bbb9ec5d96fadbb0094e63e75636b67fbe9"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "357375ab8d272e58da6c398879d088f292859d1b640937c29710b601e0f84320"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "357375ab8d272e58da6c398879d088f292859d1b640937c29710b601e0f84320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "357375ab8d272e58da6c398879d088f292859d1b640937c29710b601e0f84320"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63dc2143f4fc0b69b8ec3021c010654979df306f8bbd5543ebb4d969cbe09554"
    sha256 cellar: :any,                 x86_64_linux:      "46e1a99d599b83312f486e9620394c2ed2f51f51a6186399da53a23096524d02"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gotpm"
    generate_completions_from_executable(bin/"gotpm", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat /dev/tpm0: no such file or directory", output
  end
end
