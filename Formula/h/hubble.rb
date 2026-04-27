class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "575824523198799a2b0fd1e5ff1777de9a1962d1a41e31faaa8695442a5be23b"
  license "Apache-2.0"
  head "https://github.com/cilium/hubble.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f9c4b9088ebe17273edd057fdda087ed3f59b2f579a6c7568a888c4fb5afd7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b2fe5f6153ae0c17952578d2b30c12373200fcd6b6d98e15cd2b0d94da2f6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20af894f38f6b6d0514e6e6c45d92ca73c3779c92503c3b195d04ca863140d79"
    sha256 cellar: :any_skip_relocation, sonoma:        "25adb578d9b3f3694913d6d8be4e97d3a24de147b9985f4a9b8f1baddd070d9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc27cd20d25364dc397c373179e517450e12e01d5b71a8e870f30bb2977ad341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e2f19f31f0f13342c11830c1a84825c2a70ae05a46a661bb395a1441b94e1d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
    assert_match version.to_s, shell_output("#{bin}/hubble version")
  end
end
