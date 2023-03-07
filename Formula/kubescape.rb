class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "46a1114302bb1aa1391f13bc97d29f7d5b24d1ced20a7e772550157a7a458c95"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2faf4b4c825d83ee7e3abd4cbae9c51379f67520a1cdff1a54e264bd63c9cd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed796c76c8ca44ddc67401693385b492dca04e9f291b638aad1d306acd67566"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17e198130609a3ddbb75e3a6fe5e9b3b32a1e5b05a13924e375bbc2842069379"
    sha256 cellar: :any_skip_relocation, ventura:        "65a740dcb94c9b4824e5dcab98526e5679c49fc4f06c45c18de3cdab88dc5957"
    sha256 cellar: :any_skip_relocation, monterey:       "78afb26e85e6e9c460ffe19cace3de8527e55dfea8e0794293680837b9ffcbe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e773eac61d5504bff6cd0124a6ad598dd9f9172d0ff2149e1b3d4d7e23ae27f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ca469dec79c2b93337ca096644cf85ad6ffe12f7c204bae27bf0e79a8cdf67"
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
