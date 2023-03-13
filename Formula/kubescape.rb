class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "b97bf46d0f3257152679d272f1d995311525072f47398cece785e480d7246a25"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1fe80a71365704d8379a916d83639888b9cc47215d16f368499e206f6dccf68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0bbd7dd9627b2dfa8d562c951f4117c669c9ad7a105561b0ba9366f20d0d4ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "105c39d1dd8609033e9115e9133fa79773037644ed95198ebc433ebb94499c24"
    sha256 cellar: :any_skip_relocation, ventura:        "7d37b8bf026b7730040c19cf79bb4c529138571786ec763b8b6bed979680bd0b"
    sha256 cellar: :any_skip_relocation, monterey:       "42c8ee07cf4f0355d36c6dbf0dc244325f66475a69bdfa51bf9da38702224147"
    sha256 cellar: :any_skip_relocation, big_sur:        "22b7c1ee4d1a906ab748f7b04a5dcfe9345220bb7235d70b0b2fdf2a0cf430b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e15fd77ef99f46bded10ea9cd85ccf0c347e795419f1551caba42eaa906838"
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
