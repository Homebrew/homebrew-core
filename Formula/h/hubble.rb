class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "7fbcbc321ef3dc0ed67a84ecfe0749898ea3a11b72a3f9b279ae6b272e38a819"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280efd6ac5fe81d7364f283ab4c8f1a7882eff584bedae364bf14a51286fcdcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280efd6ac5fe81d7364f283ab4c8f1a7882eff584bedae364bf14a51286fcdcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "280efd6ac5fe81d7364f283ab4c8f1a7882eff584bedae364bf14a51286fcdcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "41f94fe9d766f71ed2b573d0057a5affab41d2a701c3790fcc8174df1632a444"
    sha256 cellar: :any_skip_relocation, ventura:       "41f94fe9d766f71ed2b573d0057a5affab41d2a701c3790fcc8174df1632a444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e682b91045107973e4a9f3153404f1f7f5b1352f3cbf2d10c857cf55fb1fd7"
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
