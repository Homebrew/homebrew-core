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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ad7aec406283f88243efa3eb77600979caf0955bf04a61574e905e142e85f06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d905098040d866c5502da0abdce5739491bda5d6a65004ff5cb5b2c8e4c91a06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ea7a77a0c2b612725657901ae5b46f14af86e27bbe0675dbe61d31f80eeb192"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50967aefe719af7d4b21accf2cd0d9ff3f02bec44a199d8581e290474ec62d61"
    sha256 cellar: :any,                 x86_64_linux:      "07c544df4bad0140a60f01e0f8fa163d655f9d92528da3df4a980fdb789b8ad2"
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
