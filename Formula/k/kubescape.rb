class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.34.tar.gz"
  sha256 "1da5a3a7b1ef8f38569ee6277fa8cf9d747f9fe379c9283011c7464b7c1003de"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978a9d1af0ac3dc951a11516b5828b7d9f67c1c349a454a3594f61ca02b6235e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e1e3f19f5e4d999fa10312b0e9c68c33663591e1ffed4c6b398caadc60757e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97f4f10187c6469e5dc070572bf44930c9a82f71e8ba84be658a915fd0263ac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc1d6cc50adbbbe6d83642c1fd76a8678d5e1660e30a3c5b8516d214f7c4ee83"
    sha256 cellar: :any_skip_relocation, ventura:       "ed137c92e456eb2837ab35a8a2cfa916cb00a5cd0b5f6813b0085088948e7d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9706c3860f04ca34a9497bfa19bfdf73950635242f8c42496546e93b48a7cf49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e1a79f01f78472ceb10029afad1e8fcc209f692d94f92a8dd5033f3a55f396"
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
