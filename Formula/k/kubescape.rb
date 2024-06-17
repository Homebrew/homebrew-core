class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.11.tar.gz"
  sha256 "1cfd60663ac55e2f5be34b0fcfe4c11e60af36dd693e6e1fed026bcceb534314"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7b3ca760643a294b5104d24bbd737b1c2e60bfaebe9bc74f5f48fb4ec767a15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1611631a7b4a2ea072998debb7ccdd950abc4ca67cd30a241618c6bc84c5c855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b5960d229ccebc9cdf4db2ae16ffa2dd47a64a8dc08399be34cc6fd80bca349"
    sha256 cellar: :any_skip_relocation, sonoma:         "417fb6b190eddefcaa968213900392ee8366b0b1faa11b0c51c76f123c6ea4a8"
    sha256 cellar: :any_skip_relocation, ventura:        "243c70692925582f79df6e41c53a0863717b537bcb45c59143b698605ec3073a"
    sha256 cellar: :any_skip_relocation, monterey:       "3752d2080cb62892b9b30b1ea5f16fcb954633f102cf7010a031600188f82697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "987b02f9bb4320d8e197a7fb728a60c2df0146fae9f245198f594d821530d136"
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
