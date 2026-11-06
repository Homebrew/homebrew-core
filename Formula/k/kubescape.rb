class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.20",
      revision: "ec65d3184f6bab7d1ad6e5db9d970d452316d253"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7f7d514ffdb950ed24137c7cb93b76cc9d9a13a5eea6bd030b1a4c98349853c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1244b92d692e1959c714ff6e88bdb43ceca89d13f0a62959557eccb00125b67a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1410da902c954785690787a977e1367deed778d35188b6ce9f17c91e6afc2c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4148709caf3f21befc07aa09706a583b8b8c8dc40d7123274330d6ddb16c9b8"
    sha256 cellar: :any,                 x86_64_linux:      "b9dfd2351749d9e36fd8b3f66e711d8a2453b19e78582361fb724a2a7d6ed847"
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
