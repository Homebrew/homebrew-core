class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "17620bb55d7a2b3fc4aabb11ebac98f6adcbbeba892a8ab11b458d261d68d615"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e03cb818f816ac85fe8c22eefb4a3dabf9be06e1f510deddad9ae09b25e99495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a4bf85311c4848c04e3313a7454fe619e7d039a56b6693f9a6b86de2366fca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4a1d027733f2b0a93af08a15cbe47a507051906de79600fcf695a168b06866f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d004b4f7fd2ae2923250d37c5426495be898d9e08b3328cc2ecef559c3fd338e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4af13394fb2dd5a7df43e824477e9c886d4ea81515a337fda60fe7dd24b6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd72f7be24dd4c0e23c22c7bc20d312b4c725457debddc12f4618751440f17c2"
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
