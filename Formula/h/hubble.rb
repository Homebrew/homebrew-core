class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "72f309215891bce6662a77928556d99454aee17b33a23ce1beeb88d7073f19b3"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8024c9d1476b969e4ccd66f22fca44514f78099026db7c3cf949250c38fa17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8024c9d1476b969e4ccd66f22fca44514f78099026db7c3cf949250c38fa17a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8024c9d1476b969e4ccd66f22fca44514f78099026db7c3cf949250c38fa17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "08d21942acc4448ecb71d64f3c397af15b35a0031e995a18135d1040fcbdeca3"
    sha256 cellar: :any_skip_relocation, ventura:       "08d21942acc4448ecb71d64f3c397af15b35a0031e995a18135d1040fcbdeca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1339d355dea41c6f5adef847bc33c07c2f72f3fcc78eeea9b50b12d6dab6b8"
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
