class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.24.5.tar.gz"
  sha256 "2ef9554f2156ce6d2eb8334f41e8c4046f59520d8813a730633a25818fece6ce"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e4932d45573b0c825c6ef27796904c636f3516274cfe1b64462777fad2509df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e4932d45573b0c825c6ef27796904c636f3516274cfe1b64462777fad2509df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e4932d45573b0c825c6ef27796904c636f3516274cfe1b64462777fad2509df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a881cb773c5004ae6d1e5621183d8d42c84e6d74fe07aadc409be33e98005ab0"
    sha256 cellar: :any,                 x86_64_linux:      "b8e0ee60074443eee619e75cf8c90f1176cc066c121f5907b3b3d8d271a62724"
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
