class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "93edd666fcc5e70dd2890728e752bc0734587aca6c3be9daba0069cfd8ef3339"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d459f0a1e3cf0437454a852c499515ae74ce6f20db5988e37f7f4d46b051489"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b8ee23eec148a50ee3e252e0aca168d2ae7cbed5c5ca439fb4c48e49ebb07e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63cf90330346b311c19c17f0ad8c262ba42f031eda1c0e1b876e56772abd52c5"
    sha256 cellar: :any_skip_relocation, ventura:        "603d756f0e816f37faf26d643304a65313b296c3423b960c2efb30c7bfef6c9e"
    sha256 cellar: :any_skip_relocation, monterey:       "71947c3ff45eb4e625788906ce24fe5eccfdf097cc424d3f2144db1a022b4792"
    sha256 cellar: :any_skip_relocation, big_sur:        "384a9a45d0dfc6e6abedcd48f52fc7c3f694700bf54ce0b760295eec7c63c02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd3a45f2a3549e774681ec59f1c822c3ca3720c1f1c7d0170eaf47966cee496"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
