class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.8",
      revision: "d7539c2264560a8685f59e89a731d6de833258a6"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a4ab22a8184310d41a1902534dfa7c38b56d6f8e8ac0808dea48a2c5f108951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d333627a70a03866abdaa8ba08680946be8bc61c89f109d4f220852dbc6f987f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ec11d0dc9c6203665db134f83608359ccf9cda0ef790f7c6d5677323eeb6ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "088247b121b6c8aa9baf4dd51f4c3ca2ca0c7ae79ddb399f29545b93f60fffdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "924f24b68ff45a8696f3ed6e5672e9912124826cf106718cad923ac58858d3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312ccc850ad31fc7af224239e42f83cd39f63bb4ead854ba5a071af509ee1b4e"
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
