class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.9.tar.gz"
  sha256 "5aecd3f7eb64b6698e4403a416a1f6662c2f58b6e764e5fe12a1d95371e6db89"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a3b2c00ee5c0c09b9d17b7cf94905b4259d094df4154ae93dd2f6667e8c9d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68c95586c49e5cc65885a8228d5d55dda0a8c56e85ccfd6a1dd52f88206e4898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9979a388f2b8ffd99fbfa18f1b82a58a3cccf2c208c45953d4b522d103aa04"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7f1901b864efbe7176cece7b27cbb016a4d0b9db14a639c13a1aa0a6add6646"
    sha256 cellar: :any_skip_relocation, ventura:        "34cedc2683136c8260a282c9eb43d65a4be412c530db0ae49ca3ad0ca99d56e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e2a22f2f3d739fdf30f6c27ffb51a781d9afca3d252c4f77622f7670a7d51268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3c0b9f2e8012ee95bc93ad9d52379ff4ddaf3beaecbaca3689cf4645eb2b92b"
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
