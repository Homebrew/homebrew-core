class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "ac0a7e58f611cb203e14f24c3b65b050931c4994794d884cbfecf5c4bf5aaf7f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c43e6a40d2ec9a09f4338311821564c53cd51b4f6d77ec2c478d524e34aa09a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3577b93b4ceee1748d4a0f9ec496f4d5845a4e13b19f333dd9f9b866756331"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d5f0cd4bf1ff71fabd3d0b3501876f00ba9c448a78b35ca00a93347b8377347"
    sha256 cellar: :any_skip_relocation, sonoma:        "c020d0d9f435bc510ce5beb5179de477a43dcadf7ae6bee43459fb322dc1c53e"
    sha256 cellar: :any_skip_relocation, ventura:       "211ece972b01aa149a97878c96975d67751578a116f748301f2212dbe195686c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2e4083010821994a723f3663f9b3fffe739e6cd91dcbe93a4f6cd6768b8df09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "018e452d7084add8e6371ff0d0fcf8cdaabb4378894d5efb8ed4b581fa2e6a25"
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
