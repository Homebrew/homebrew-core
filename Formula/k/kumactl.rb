class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "cb28582f3da98c26588c54a6439b86228191a2a4439f533ac3387c39820d6a08"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "095f1ea86f7d636e22a82f4547ef3e1b30317df84a24e423455ae643fbb4a290"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0e942dcff937d80f5f1ecdc42f331c5e73fdc201de5b3e0305efa7cb0e1b7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f742041125c586272722ad57a5e386b2fa9e3454228639ee84e0e6d32255b84b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "30912554e8aab680f2b989f3f16110787f2257c9d1d95182312b81ef36f532a6"
    sha256 cellar: :any,                 x86_64_linux:      "dda6e1770fe99027207fa04d865fcfd8def034b4babfd0f9f155d8e8538a0f5e"
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
