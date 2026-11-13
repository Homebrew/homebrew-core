class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.21",
      revision: "42df4e161a97a8a0f4e656d45bba3d60cffb08f7"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98f40da9781e119fe779810a0e93b0c4bc0b3bb758eab75bbd38b2f897a1b51f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2917b68fac65ef3001948b79fd36501019824d0a8ae891e0d0350fd8ee6ec4c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39e3f78e2c0d4e688454962d26b27bb45908234a591ec5dd59ae03d5da9a2fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca79c323111aab8455bc30f813f30964f05bab316a7d9802d6af62b431750fda"
    sha256 cellar: :any,                 x86_64_linux:      "ac44f267498062340b0159ccf1d2017710fd21a9d906f36d5efc5df6350e69a1"
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
