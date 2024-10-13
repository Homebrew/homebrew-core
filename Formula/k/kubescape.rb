class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.18.tar.gz"
  sha256 "cd0c4319fd200605a48bf9f123f339ed43eb4ad8e34bf91407f380ba46e7bc57"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2d82637655290c515cb7614d9049da5e75d661fc787ca54604872a1f44b7bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e10504b007ac0d4650c3e44de88ce2f490669d34c25f9cc97f9c90681b9eda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8db4d5af346364b75d83a4f649080e27668ccfe8e66d3ccba88444d0e89d9b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f48dea2c6543a06c38b17adb92a9bbb3db0127b91dbae9d2e5c27cb57ade5a"
    sha256 cellar: :any_skip_relocation, ventura:       "c5b89304e44dbbe4633f900b9c5da1e21898fac935cd2dc6969ddf1625f4aef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b25152ca5bc69c499324b4f57400cd9abb1c63fcd7083cd65a9e164b4c08694"
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
