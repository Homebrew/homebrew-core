class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.10.tar.gz"
  sha256 "ec05caf87b552568cac7b8677a676c7d75cea3f16f659d17aace1c402b2d688f"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31010b3816c68e1debb0366b147cde5d81c2f84e6b16bd912200624ff6f9d4e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eda0ecccc6af80590633cfd106ad6fdae42a91aa1008ad1b69c82012c26bd1da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0674645eeba95ff3118ff48a3fbc51c94a65ec395422c0549a770fbf2c1f76cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "763bb86817a908f6cf25ec1d04a18b52b0615548046327afced2702434e31d3a"
    sha256 cellar: :any_skip_relocation, ventura:        "17aee1be03d92e3533d5da41bc912286df8d5158ba5c1d24232943f697bc1de1"
    sha256 cellar: :any_skip_relocation, monterey:       "cfa6da426c2ece84f43af36247d5cb6e8524088c72b980e8b0b4b93d7f2d9c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca1a5271fb40759adfdd64c33f38acab89e35683690390b2c5d9efe72e0ed01"
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
