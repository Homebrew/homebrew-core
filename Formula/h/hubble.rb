class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "3adf90df00eb93bc92a2ae086aa2ade496e1d839d5aabf85136f05845df4f508"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0835e793f5f36eb810284aa8806967690acebe28cd90a4dc559a73992227983e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f091fd6eb072f61cb05e860e93d76368a2dd7a8f9988d7a0303790977b3da4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eb741c0d9c9072144782404e0ba9b97901e5ec70fc5c0aec419d72d63376250"
    sha256 cellar: :any_skip_relocation, sonoma:        "d581ac9bb242be83cfe04047b86b6845807624ad2afc6b95ecf38aa32c0bdaa7"
    sha256 cellar: :any_skip_relocation, ventura:       "d59ffe51857aedc7d8285b500557c27f335be80c56691ee1dcbbc7466337a91b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddab1e0aac6d0924ce4f1e43ec86f3b612480a5d8a4dfb420a722b592518871c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4f96b8c867452eef39c0068d4207cdf67b0b4424c54d117092516afa48e1ca"
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
