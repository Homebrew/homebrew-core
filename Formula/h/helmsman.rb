class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.17.1",
      revision: "9f1ea20e04d3ddf2e0974f2e1114aa25d71f7f4d"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f3fcfafb13a1c2242fead84ff3f2852157d34b4c19285e5e2705ab3dcb4066b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3fcfafb13a1c2242fead84ff3f2852157d34b4c19285e5e2705ab3dcb4066b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f3fcfafb13a1c2242fead84ff3f2852157d34b4c19285e5e2705ab3dcb4066b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0b7e6374f25556479c46efa1252f68a9b1793b64568c71e9deace2924f5d13f"
    sha256 cellar: :any_skip_relocation, ventura:       "a0b7e6374f25556479c46efa1252f68a9b1793b64568c71e9deace2924f5d13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76b767dc0a37dd3d02d9a8c09b578d85cfb5c0fccbaf9a848e54a2a00d0a0ec"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
