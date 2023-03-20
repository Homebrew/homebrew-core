class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "13736d48c180d1a78de91e5b99c3baa232f21cbeccf89bd4fd3f8c500e5a445a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa5616fda34cb14d2fc51e2155f9fc12aab1854fae5b784287196f5ecde3f69a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4489500ada4f5199db99bfec3ab4336f550d7d9d515cbe69c01dbb71f4c89b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b741127974588b0acc62b5ff5db88635f51179bc2b7dede20ae4e1d700e8fb6d"
    sha256 cellar: :any_skip_relocation, ventura:        "18df7f06b0bde91de62589d507f2b491570b2a58353a23d595a22ddea9d6f425"
    sha256 cellar: :any_skip_relocation, monterey:       "c31b179022e1f77f3ecb26268e439b57a71554b34be876e29e24dba74695f974"
    sha256 cellar: :any_skip_relocation, big_sur:        "acb73470d747b4b192648ff37461f5562d7594e74aa80e90848028bc52fc96a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c51fa70dda8494bc474151826acd9e6c6e9535a7c1d9c0c81f0d198b131c29e2"
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
