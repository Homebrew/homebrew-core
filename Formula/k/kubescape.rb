class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.11",
      revision: "8fb2eb1db185637c5ea5365dd4c05bea4f165741"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9dd113692ce91d4392449e71e165d216a8f7634854451dd6cdce496e7db7441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb29c486645544439b1824f6e041e783069bfaf65368f4a6a4378433701bc8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5320cef1fb0022c89e359598f26d4f032899829629e89623493b8534cc6dae"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea65f1f7ad7abb107f27890410d3b138418a4812843bfdf84db2d70c92b5a38b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f60a24b393a0ee62519d28f00c448e5ffbe2a6dd7bf7c59a77d09120ae840f"
    sha256 cellar: :any,                 x86_64_linux:  "2960ad890cdc78f73f8c7e4676d609e5bc8c4f76f5224147e37565ce928c0128"
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
