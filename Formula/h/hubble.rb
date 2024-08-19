class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "10e7789a2a3889f06a489ddf42b9a499eeb0e8a67e05e120d68b66549e65a0f6"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f51c87dbc9e0e35f7184c2ae9c00c4af3a6e7a988af7a914c1928c7c3e94896"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3272e25c3064c13971d18fc0dad635952e68cf0d9949e340befe1730a1f782bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b2b70ebb494ceb6636369fbbbe079f5dd83c2c7b7f9e5cb5653af7e11189ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "15933f97e0b4183c4e738a3e8ff081f5d7673bd17eb3278159204498bf69a287"
    sha256 cellar: :any_skip_relocation, ventura:        "786140d4737d7016411f5222ca89caa93cd374e43043926a7f196ed014f942af"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc0bbd4cf7725909598bea3f2396afaa324eeb62dea888d9dacbbb3e4bde38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2bcc31d96c303c40c7b008fcd4b13ee850ea7d9c5481b9e1db86dcdfa3d1d08"
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
