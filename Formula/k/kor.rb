class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3556833e78da34d4ec66bd87ceaa12aa1550d2c2d250141356f6684a133e1eda"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6de6766b3c86e134cb5720ef454a92aba17460b60d63729712ab79c2b29b5bb5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a937de7d80bf6ee2ca0464940595b57bbea6f71bfd44f590b4fbc8ac2c62cd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc164824872aff9254b00341068c0e6df62f6a214887c81798277f5b3964ccfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a5008d7d63bed82ebcedf0fa8f7ae135091232a312014c59bc2a10315ed603a"
    sha256 cellar: :any,                 x86_64_linux:      "eccc674970529c4e121d6b93723ba10f2d2bbbc7329d3e77a64f56d545fb5c5b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", shell_parameter_format: :cobra)
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
