class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.5.1.tar.gz"
  sha256 "0922d7d3585f856ccc80da20affaa4bc52472e1de76d2c6c9d92d8233e221766"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf1d63995b803a10f41bd84dadd0fafa358edf4e2d6ae0ba8d4d1d5f2d65ac44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf1d63995b803a10f41bd84dadd0fafa358edf4e2d6ae0ba8d4d1d5f2d65ac44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf1d63995b803a10f41bd84dadd0fafa358edf4e2d6ae0ba8d4d1d5f2d65ac44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "566c385a969d570939eac2a7d418695f8a717e04e1ec9499fd49f97912c7a1a3"
    sha256 cellar: :any,                 x86_64_linux:      "fdccaa88255301160d8fd07c95af47cbf9b6376739fdcdcfb77bc44d8675c3bf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    ENV["MASSDRIVER_ORGANIZATION_ID"] = "homebrew"
    ENV["MASSDRIVER_API_KEY"] = "test"
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
