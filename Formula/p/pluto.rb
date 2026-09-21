class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.24.4.tar.gz"
  sha256 "ed5b315ab5ac90ef4a57c665107ce47e7807b7eedd0a73be18459b34111286b0"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c6d30eafd716dde680907f953ce1e86b8ec1f1f6b944012bc1d5805a3f38c3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c6d30eafd716dde680907f953ce1e86b8ec1f1f6b944012bc1d5805a3f38c3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c6d30eafd716dde680907f953ce1e86b8ec1f1f6b944012bc1d5805a3f38c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27e61627d5989205e4b4ba706bc636150afb4f3fc9dab3e5f228db212a2aa051"
    sha256 cellar: :any,                 x86_64_linux:      "1b319b618401dad199bcf9cf9b750bfca1a8537c7b9bcf0e58d662398e5baa46"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "cmd/pluto/main.go"

    generate_completions_from_executable(bin/"pluto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
