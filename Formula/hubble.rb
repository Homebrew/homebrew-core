class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "3000f990a17ea8a3e97ee217c5d6165438b19ca688a8fb655b7340844c160c55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee3d8441b32c1f7332abe98c37e429505fde4e182d77922251d6c050dbe52b92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23d5436d6a773cf7283bc640bf0270c82573d33587d9ad370a192db632d1737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0110caab7f4ac7cde0b25715dd319e8811cb907944a028b27f5598eb55e8409d"
    sha256 cellar: :any_skip_relocation, ventura:        "cfd2bf2f244bc32d77789b650a8ec0a79bfacccf59c00740e8e59428f9e38519"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0f49a1f9ca02faa0cc0b87c1a63e687e650dfceb43dd81c9f63b748d99241d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e6b5905f3a67642723823e43603605f3d9ce44c49b5f837c980d45ceb1562cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc5a1d19b435aec129b32ef718432d6ed9962516d3da35b5d1a384d984b950f"
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
