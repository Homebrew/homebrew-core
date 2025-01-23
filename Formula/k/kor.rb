class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "aeecaa2f4faf3c2c8dafabe0124749c39fce455f5a87565dd291706547c89251"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "771f6e0a1b10b5fc2a30a8fdd979f7b9aa9050ee17c2921693c9358e99eac62a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "771f6e0a1b10b5fc2a30a8fdd979f7b9aa9050ee17c2921693c9358e99eac62a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "771f6e0a1b10b5fc2a30a8fdd979f7b9aa9050ee17c2921693c9358e99eac62a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a215ad9521e062a5f955943c3ffba5c30510f60e7bc442f6eccc60c619cac941"
    sha256 cellar: :any_skip_relocation, ventura:       "a215ad9521e062a5f955943c3ffba5c30510f60e7bc442f6eccc60c619cac941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3af78a5ef61c45d2e0705d5233dce3f1c82bd9c64717c3c9e6b810b8504ac76"
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
