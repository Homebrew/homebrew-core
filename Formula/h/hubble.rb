class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "79afdd77b2b9406bb6cdd90c0a5990fdfe9457c08837af458a7bb7717b58d560"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4210634cbfb63e325c4fcb0caa54d95600c68ee72efb43c0f6c0b7d37171b2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d729dec4e8f713d1e0e77ba55306ffb68a5a68c9a4c0f0acd5b70a96f3da651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d34e4e9eef900d79d172443b2d73fe6f41a34b96e3b1a5e48336bc12d650b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "cae4b36388efba845b960cc11b96d1080f2c1005be4ea312c66d05bf44def11f"
    sha256 cellar: :any_skip_relocation, ventura:       "65c8bd611be75a636bd448ab9a13f20185001851497940796aaefeaf4ede1265"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48bb390c83f4682abef8122759a1d994ad631e3fbda78e028ed573e32f98f130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec6dcc7737747c056c029a1279b93e3141e82bd92aea0cf1f3804981860a495"
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
