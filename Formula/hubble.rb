class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "7319020bd0cddfef5d60ecbf97c176a97464af33351a67244fe395e1e27e4e38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82d113a3feedb14fa94e70190234865f5d0ddf3ee7b2f41cbb46dc22b247bf45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98df3ec63eb9a733bbf815a8baeb07a20fe5be13a7ca712f02def822c2ae5db5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8ba020b97761eca031ba0e36e01f39261d300a1206be88deb0a5b85633be9f7"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c04e45de1733c08db40ea43a751e99ddc7194570fa5f3fad57360cdd9e2d04"
    sha256 cellar: :any_skip_relocation, monterey:       "48ba32b50f50261a729fcd76988ea2f4fd804cdd1385eb55a8236b334f637455"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7323e424c3f109cd1b10f4a65c0c627d66dd1938a508d72c6be6a76f7cbb42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0baab30f11fbee1b0ecbfdd14199cd2908a1b2cc3a6a002a811a925781fa176d"
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
