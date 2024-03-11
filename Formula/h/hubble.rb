class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "88f5851ed98948464272895b70a620b5486d3d2792a11721178f832cdd69eec3"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae199c96afe7f4dc75d7d98af88a9f0fb2a2cf25d328dd4731390526e94d330f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "631ae4149169e308933a0f9d4c000eb6a009e668966730a4d7a0f2a2d8f11e1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ebefbaeb49f2561c27185e5bcd2cb013e4b066bea7972335e9644388c80f58e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f3329e3f2cbfe8bce4be447890d94f8c8875eeb04b2171072ffab0ea14d21e8"
    sha256 cellar: :any_skip_relocation, ventura:        "97e859b2e5d33fc9806935b3d0051ac8f2588b13a7575692cd0f1ff57b853ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "16c63e30bad24ef1d75ae1ab2b6ef003a0136a4e4713e873c9bb949aba479946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "736f26289bc874f8747afa8d5365adc78552f28b2050c8db5cc403964d586bf3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
