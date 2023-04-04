class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "469485f6ab9d0860652c54375e147ad29c12c259b6d440db726ac34e325b7ac8"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd251b59c6f6099b6696705952d2df9d90d68774e02b62eea69784f258aa12a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffbda3651f24e6ede930a7d860e6694acab1b95703f2629bc8baf75cfa879195"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37ea2e10f01b7491d9ec59c066dd35e3e7ea2483858301030830b72aedeb7468"
    sha256 cellar: :any_skip_relocation, ventura:        "02fca7e38f65fc204358dcca8a7eb715bf322fbd14dcebfd58fc65ba9c3905c0"
    sha256 cellar: :any_skip_relocation, monterey:       "d14887b5bc45bc72a90c3a87cd09056d88d27e4632dbb472cd4753493690617f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9502344822105dbafaf3d34807bdebd4c0093cf31b587aa09a39c1d12675958c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ffc628d0d90943e3e6f8d5f745def1f52cea05de5b9e0c5f863ec41568432fb"
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
