class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "28f5a7adfc5f5a409613bb2ec10aaf6bb78e49d83403ec8393b3c55d60d0cb46"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2554f9d1fa931882ae49e29490af56a0ef52a24305e426fa22f9f1f7f9b977dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8386e40f10a43c4f5f253d341885c478a31e0e82f3f6ea8a613d4ffef4bf1a16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd55f967bb4caa262f59cefa4095600bcadb09fea37900441d8b46b8498f3bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c677a22dec7a23c9bb11a11a96caeb71f69e1fab58d245699ec573a85d44b4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a56a2a25828cc22b26ce709d4e70ad00c96789226b62296fb5a1dd4aa5bea55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c0daa82ca05c7a2d95efdd69e54c3faf5aed54a0345269ad4a35abab3a18084"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end
