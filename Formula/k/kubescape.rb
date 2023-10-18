class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "de1465db108043918209403a9633ccc694131c34b1339b7ab851de3065f54dbc"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5a621a95a5c7adc58c31490acbe07ed898c17750c098164ddfbda9bddc71b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78c01ab720eeeb0c7033acff81ec7deed3198f608455060563191e6dcc655ba4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4794c0c4f6ef176c18ce68237f4024322106f4d10d5e1d61ecae516c07ec3eb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66b1a517bb8b74ebb6f868f4ee8c3e3097daec2427198ad3f28deaeb7b11dee3"
    sha256 cellar: :any_skip_relocation, sonoma:         "034bd503a9e2dd5e7222f371076da9f9fd9cb7d20d6ca40473185a66561dfe18"
    sha256 cellar: :any_skip_relocation, ventura:        "6cb5b855cf0d11d4fa2bec68c92e5e11f18fea14f9731a86f19622d7f56d9769"
    sha256 cellar: :any_skip_relocation, monterey:       "12ba126cddb3a2f8df58cf45a571755bb103f4026c6ff7a6120de054f6198bfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "351f9e1b9168fa51e2d595cdbb98ffb8a4b6cfa127fd146dc82cbe1013bd1332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80be887726225e166eaaf22f1e196f2c13f1fb1f3d545b6a4f9e2b3c2de50beb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
