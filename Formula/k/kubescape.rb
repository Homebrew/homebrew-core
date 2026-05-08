class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.6",
      revision: "c36463cdcb4fbe2646e8ebc819059ef48eb752c1"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9799199a86487addb997be341d1d9b1de16ba40701bdb32322d4abe39c09ba51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db9e61315401136f0c32e69c1db5d02c0f5e6c62ee09f49442010bf0f26bce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3fc652e0f71c369b28ce999369e8082b8da136f63efdb7da4b3e1896a34c022"
    sha256 cellar: :any_skip_relocation, sonoma:        "a31f3b16b8f2418bb0bbbef83e1864cc5fcd0956721700d3c0ddb146b486ddf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a70cf9fc6463aec2e2a71593befb1c1f987d47b652ff9dd123b82320d6c03984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b60545d25d4c53c8bc4da678a47b8f855388bf1d9fea554a3c7c92f7cecb98e4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
