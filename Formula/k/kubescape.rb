class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "31ee32770b4eb5514b2f8885a1fde83abb0a5d6d409704a8789c87948dfb806c"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c77a494135b8db5a220b828dcc01c7c7d744871e6aa653890f182bccf974c592"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1eee7f320e606c7723e25e2287a237ee1bb62b4ac19fd6b554d1eda3f18b0fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ec4709cf2979e28ae72ddeca2d7ca5954363e77daea65453b1c83bc05effcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "32448f81c2deaac8bc5627bca2958c9230039b93a45a912b9424da1cb4603593"
    sha256 cellar: :any_skip_relocation, ventura:        "86e60697d092765b2fc14cbb4b8c317c10b0a88b803e2d6439e20a87256bd605"
    sha256 cellar: :any_skip_relocation, monterey:       "f6dfcfa2c74026b3cbd028322a95ff92b191266e5d7da4f3378c5d449ecbf0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c6dbd27b13ce56778d55b604e30c5a60b37773a015e0a23dd959a1312cf993"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
