class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.102.25.tar.gz"
  sha256 "fa9e1b61f038c807098f5814d8b8cc6097269d821774e23b344c73628522a538"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d425b4a892f806fe376663e1b523db67d451cdd5245820d277660adfbcabb05d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d425b4a892f806fe376663e1b523db67d451cdd5245820d277660adfbcabb05d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d425b4a892f806fe376663e1b523db67d451cdd5245820d277660adfbcabb05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "831c6ff5d4efc81ed4b651936f156f8c8543a806ff2bd11c6007f2ea4e8ab8b9"
    sha256 cellar: :any,                 x86_64_linux:      "91adcf4bda203e886f80133d548d7ff9e3210bf47b6c1794a5ffbc3054d442a0"
  end

  depends_on "go" => :build

  # Fix linking on Linux arm64 with Go 1.27, which rejects cpuid 2.0.4's linkname to `runtime.sched_getaffinity`.
  patch do
    url "https://github.com/depot/cli/commit/627f8a6dfad7e7f2f33c774d3aa22af9884f0ebb.patch?full_index=1"
    sha256 "bffa3eaea34bebeeb3c27fb9ed326137b8824a1ded170eeeb2cdd91c30dd48ac"
    type :unofficial
    resolves "https://github.com/depot/cli/pull/570"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "unknown project ID", output
  end
end
