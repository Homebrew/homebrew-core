class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.18",
      revision: "8a87f176953a0e18b0efb996a0a5aa0b78fe3ed6"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9424575a4e9996a3d839192800eb6a4f43b479765a044c154a91c03213997130"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b995d8cb2d2f0304ab953a6c81b8c2726ee09f85007307fd00f0c3a7bdf2a93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a7742910badb052dab1cd9ff66a5defea66ae415239202843308ae23b5bf6fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf2e3b718080877c3a4bdc942dd07ca187c52ab10113ec4d30724965b533f904"
    sha256 cellar: :any,                 x86_64_linux:      "e8d590a6db5bc1f771f0e70d43aae079a4ee19510bb9b87d8be60d59ac4d7934"
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
