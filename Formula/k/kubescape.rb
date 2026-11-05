class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.19",
      revision: "9780473d81b3b3e036408d6323b162a197beee07"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c339903ef57f500f25817a714371f4fd7a1a15d10361f30c525bc18b3e4361c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f29d676bc17a0eda53756e5ac1fd84dc0dd4d02ccbe81940f9995350fb58277"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd3e0ea0ec53bddd936ad6e1bfddc72ad7eac16adce5cb6909e3910b74497f9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b484209102c85654e082759fb02d4c181b555b78565ddb14fc018da2a7c09c0d"
    sha256 cellar: :any,                 x86_64_linux:      "cf671644c254c69373d5fe169757fc5b7c8b0c24eff4ac45bb1a9d4440e75510"
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
