class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "929ee40b4b3e5087a88c448970509c626f46ce8080b6e36f829658765a803800"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba68ca94bdf9877fc38aa8b433149f145145d2edc66967f46e825fc8b3491741"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8410afe1378a9e3e9e0a07d91b7babd0c8a73df91626055aa84dcf2f78224e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "218570f6f3228b9bdf28b8cdb2c89c5f1713d3ba2d91ab455e86d17c3d29481d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3cf1cf836071a993c81d142a7565a00fce0fe35452c59a3f40b3efd60218dda9"
    sha256 cellar: :any,                 x86_64_linux:      "324a48155df75f132a1092d333b1a8e970c4ebac34730828b61c6f18df57ef49"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/cilium/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
    assert_match version.to_s, shell_output("#{bin}/hubble version")
  end
end
