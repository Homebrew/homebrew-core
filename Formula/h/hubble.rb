class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "34d2127677dace7f4b54524dd29c9b1d0a7856ef71d45f3d48d32d00699ccd97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce6af132b54cf6f3f081e2e85ec28e8a416161e07d9849468404e67e39af5df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b58a0693f468e47cfdc60411e87e7b146297f4ff0a571dbc85f08b23f36df10d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0461f6c9cdc25e4bc3672cdf0f23c182394133b88f834c6eae561282998385e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb0f6b8466f386538142036a456d8261e9d566b0bf735ae4d4a74b7186051a41"
    sha256 cellar: :any_skip_relocation, ventura:        "18b052e9a5548c04ab5ae6394c43b80759d18dc162414d6b205c5d50cdef7c71"
    sha256 cellar: :any_skip_relocation, monterey:       "3692d2cd250b6b874a732fe07cc39e16f84d0bec5045a873e7a0ad80ca6e11a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b432e822ce9f6ea0eca8c36ec4c54ef4ee7159880ce2e5b266147ae88178db"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
