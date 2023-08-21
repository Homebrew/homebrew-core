class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "80173ee60c8860dac67865952b0b74d00e7f5ae2786193ac4e531a58ef58c1af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d84dc6f35bb5033fb7ae9317a458c5f66720c9ab88415923e2e475b35716c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d4f0149e4e9d7550244b656107fcfbb66f312d12cbc63d43a78101f72eaadf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "995e43860b7d7e4ff16534d4eb19b940587df6abafc499d48eef921b621bcb13"
    sha256 cellar: :any_skip_relocation, ventura:        "9607091e5aec6b2b8ebe525a2622595478e2982e8e416a2ed28bfb00c5295236"
    sha256 cellar: :any_skip_relocation, monterey:       "7639419b9dccd6d73672b84feec5b27cc464aba401a0bc74a35706cc29e28faf"
    sha256 cellar: :any_skip_relocation, big_sur:        "8458002eed50d2648dd2082ddba6cf18b8ce87357295d18436899bd85c6100e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1006e2fc9b46fb5108aaf4e1a778f5ac02e8eae3306aeeecb8f65d1f91fb208a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
