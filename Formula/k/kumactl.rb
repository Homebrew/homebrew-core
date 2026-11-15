class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "42873f8cea085979efe544472e561235c32055be822684b97959f5fb162fde64"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5043e6eb5b50475b148c18f0e0da260f6378144a26b2bc862fb2855526c062b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7afb90baaad3357939c5fe2593d8814c9bd7763c084706f21f27bd008738e3d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91811f15bf8d43d7cdd1f4554cd98239dcd387d69330a38cdf11125262a6ea0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7057c7522c5d1374d44e1beccb50b82a3b5191b9f0cd64f1c3d081366cfcff9"
    sha256 cellar: :any,                 x86_64_linux:      "f4ad8867ae82f2a2c6f00f82d45156133d715060334fe7c3a0877381435997ad"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kumahq/kuma/v#{version.major}/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v#{version.major}/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v#{version.major}/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
