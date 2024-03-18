class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "1e59ab2c3dabb544473b7fb78b83c3dcf4bc77851eda3d5fbf0b9607ba99c9c3"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ce277955dd4022c22ff5e219b5775500bd9981a48b6455b58b06ed905dcdb86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14b871f3b37dbcb260e9ea75d16454306e3a471b9cee6c9529c60210c794f849"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fedd4fc80929a3e4b4f1ecc099eed64f04d3cf9594aba9299690101f933c39cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "da63d0d7ad2391bc7e0e23ab13e2753910a115a111ffe46621f7290c50efea4c"
    sha256 cellar: :any_skip_relocation, ventura:        "cd2ead08e0919cf9a7b457fb1e04fab7e414cad0e83df78c2967ca3e29cbf9db"
    sha256 cellar: :any_skip_relocation, monterey:       "61323cd58753c3b023be070aaf7df0fa581506e3fdaf9393e6062055d2e03d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c7193e386f492ff96c57cd4efaac3e837582d3c456954523dbb8daee91d8b35"
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
