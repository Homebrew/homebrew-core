class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.4.tar.gz"
  sha256 "c6350aa7e1abbecfaaa9de0cdac1c358fb838ba206a1a621d74ee08b555f3ac4"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "125bf03963824a57919f20b132fb10f670c1687c65836237db4d5fd352383759"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "125bf03963824a57919f20b132fb10f670c1687c65836237db4d5fd352383759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "125bf03963824a57919f20b132fb10f670c1687c65836237db4d5fd352383759"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d6d282a9a33e8b592ea0329f4b5872e2a23e49e6a41a256b94b92620cd4a950"
    sha256 cellar: :any,                 x86_64_linux:      "6f5132f384b0417cbd2de3a9d952e0528d3736c93b212cc84d9fe33a79d9d966"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
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
