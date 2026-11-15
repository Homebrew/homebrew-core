class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.77.1.tar.gz"
  sha256 "5e7aa448e81acb9b9d1d066117853c1ffdb38c417a5db01ed1c8e3fcdec83960"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6321653be05af035fc0529b7b40f3386ff40056351a55c3b13b4ff5704f4d74e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6321653be05af035fc0529b7b40f3386ff40056351a55c3b13b4ff5704f4d74e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6321653be05af035fc0529b7b40f3386ff40056351a55c3b13b4ff5704f4d74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cedeb366d9abbc29de6f483192a17a6d63532ac8f6859b5d6cc1f9d4e8f5cf73"
    sha256 cellar: :any,                 x86_64_linux:      "cb705f42f491b39510cb122fc93c95f16a520096091c701c64ba33b5eae4edb0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
