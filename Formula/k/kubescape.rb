class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "de4b7aa21e3eb903d8bb3cd5d879fe2da16739036a4ec9766ec8fad78d627d78"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35056e55066672b8744cca27a3919f420d34c2f1479a7010100111e0887b0db9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2528d07b441fc557f02f799ee1afe6b62f55fad353768025fa2717a7863cc464"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eebca18c2369d1fee6a47a4cac32c1756971274f86a982fd5b61dd390fae10ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff86d35527c816ba8412d57a7fd1b56a82a4456ca8da6424ddb2139d7ff0d7e"
    sha256 cellar: :any_skip_relocation, ventura:        "444dc83f86afb80df601bdae299c4dcf3cabfb18b3ae9adae739632aa0c8fe3a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3a7a7211d869d5e1459ce64cc4092bbd2f214c9c0ff418b44b671137d534aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518ee088f63dfeecac28175f35accd5a244a7de35570377dc67da401bc04573d"
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
