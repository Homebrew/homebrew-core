class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.15.tar.gz"
  sha256 "0ca32de35d8db9dfd186f12c124dd3668b70cbcb5dc1530812c72a789b52ca5a"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b918869e9b775e10e0f5801aeb6bf053de8dc7afdcfdc6cf312c5151c580146"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "635d66db0615008c912ea495e5419d9aae87554f471f108fbb8b60e9d2ba0c62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "636ca315197ba7c5cff72b75543032d92f9b1ca8571f38af1bfe420e36b1bb45"
    sha256 cellar: :any_skip_relocation, sonoma:         "b003a29149f19be3f136aee9c054e28fc23c347ba27342764a90b4ff2dfee6a2"
    sha256 cellar: :any_skip_relocation, ventura:        "ad2bcd0998c6e83145710318199ebcfa0e4c4502810633b4364aea41a87da84d"
    sha256 cellar: :any_skip_relocation, monterey:       "999452517495cc4ed19d75934c3307048d6393dd76dd0d1d27860d0fbdf3d084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a10c9036e9bf9ed2dcfd98804c612741af764b9d9d454a4be494c022625959"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
