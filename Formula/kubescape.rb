class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.161.tar.gz"
  sha256 "165222d24db46b70a664fd70e8918f478c39c05ef30bbcbfb57c05307d88ce6a"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ef7dc344edda8dc0cf2cebdf86169a63675fd0fbe08c9e57707add42839a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "264415412177372be6ce2e92673a7469115ff6ce6c29a6efec1eb2a733821695"
    sha256 cellar: :any_skip_relocation, monterey:       "b33d66b12dbd461c7038a53fde23f027046ca30efe51bf66407abe96abf5d934"
    sha256 cellar: :any_skip_relocation, big_sur:        "b38436d3d186c443b5deb669ac7be828296618d0f938dd68dc97340517d58f8b"
    sha256 cellar: :any_skip_relocation, catalina:       "520774f9ca98acc82a4f86d2cc36e83684ad411f41bed5c262296647e1787b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f380152c0c592450d46da3f3731853a452de6fe0a2fe824212465711ff6a9d"
  end

  # Kubescape has been disabled since it fails to build with libgit2 upstream
  # https://github.com/Homebrew/homebrew-core/pull/106523
  disable! date: "2022-08-11", because: :does_not_build

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/armosec/kubescape/v2/core/cautils.BuildNumber=v#{version}
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
