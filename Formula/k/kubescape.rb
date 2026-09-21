class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.14",
      revision: "031cd40cc8de696fa30a648001853443019ec97a"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f3cf08bc15bf3796bb9fbde28bcbcb13aa67dc602664fe219676473058ee738"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c05ba5810a3f7d9b0e7fd37bfe1a595af14e4e2189690deec55441b59c9e17ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d762b89ef65a3f92c520ba2d7cb49b27a0fbfe8bbda5afec60f87506f9854be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "153c218f8ba0d4817b79b806b3024f379cbaf73ef9630e9ba9dd6b5bcfaf30f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e829641eca8e13d628d6604c4bfcb7c089846866a9089f50bb54bd3310a2d3a"
    sha256 cellar: :any,                 x86_64_linux:      "bce706aee9c557dbd5d25a74d21ff5bf53adafbe041409750291f1826297ea34"
  end

  depends_on "go" => :build

  # `test do` block downloads framework artifacts and scans a remote URL
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
