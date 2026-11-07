class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "c3041595f6db56021d7b427d069c7175380d706e9bd96597d67911be6c95bcf2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8752f6a3da7d8d83d1a36a0adc0f3aabf9896934b7e84d07e3ea5ff5a6e336a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "327e65c1b8f2ec76c566211eaaf84d9ea716ae4a8679e8a4583b1b10f2424854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f24cdeb8c3230ebddfeddff65061d880f2757a117894ab2e383da7ef748c69f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b35ddb87ad41f31562aad2de9cf771c5615e57ad7f95b169c385332e9b1c6f08"
    sha256 cellar: :any,                 x86_64_linux:      "26e7ac4bdd79af7d10717484f5f24cb78a301ab221393698f833887734a92adc"
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
