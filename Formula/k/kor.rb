class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "d62ee695d55cd691946f9565a9e46762f145b78c2f6999ad3f1d8b69c2b2d1f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7658812662aa47fb9039af428946a0b65244fa63ecc042415c1665a7f19ec5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7658812662aa47fb9039af428946a0b65244fa63ecc042415c1665a7f19ec5f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7658812662aa47fb9039af428946a0b65244fa63ecc042415c1665a7f19ec5f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac83c8b1a359adf10eea837f38c3d00ced2697c194c02b2f4ace0cd09deb1b87"
    sha256 cellar: :any_skip_relocation, ventura:       "ac83c8b1a359adf10eea837f38c3d00ced2697c194c02b2f4ace0cd09deb1b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a097ab237d32d6a069d95b8142b8498c15ea00a709368e823a4da9261fda94f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kor version")

    (testpath/"mock-kubeconfig").write <<~YAML
      apiVersion: v1
      clusters:
        - cluster:
            server: https://mock-server:6443
          name: mock-server:6443
      contexts:
        - context:
            cluster: mock-server:6443
            namespace: default
            user: mockUser/mock-server:6443
          name: default/mock-server:6443/mockUser
      current-context: default/mock-server:6443/mockUser
      kind: Config
      preferences: {}
      users:
        - name: kube:admin/mock-server:6443
          user:
            token: sha256~QTYGVumELfyzLS9H9gOiDhVA2B1VnlsNaRsiztOnae0
    YAML

    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end
