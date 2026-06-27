class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.9",
      revision: "002e791cd39fed51dd4a86b321c6d184fa672349"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0457f46c4bc040aba1540aa8e87283951802b6e504e6b6d1146e041f07384b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5040d23138bf4c489df05cad718c1b87376d8b52c79bb988531fbb2ff854242c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49f793b5c3b008595d18ff64b7bdb4eee6ab4c9c8400162aa37319a84bc6c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "199afeb9c9815366bb20aa5d92adc48a059bc8176931ad789cc6d82c80af7648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "025438f2e16835ba586996bba968f5fe093aac5e834516ae80907be090fc5c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cadfe39692bae78be6c6e8085103af2dff2a07fd19df86a2a6886a4d4a5cb97d"
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
