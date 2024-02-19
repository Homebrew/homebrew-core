class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "4449e58f9beaa753d9a8c951ab26a1771b502f545ce5c303f390394c715b01c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b870b70ff6ab763e52bfd7bb99ae51d9aae10b2e0d42f19c9eb45a683e34b03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa3823a33eee955aedd24adc50d585ea335887fe65e703d566c417fdd45b8fe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3c1704b9f393d8029df1de9018d787e7ad8397b42d630e79bdb57225d20c70"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a4e9757d0f6cc8afc542df019517b231299048035345785a8311d93ef88320a"
    sha256 cellar: :any_skip_relocation, ventura:        "c1834a113ea170214ab413f33dc14bf6bc5871071fb804648ff1ceb135d27cf4"
    sha256 cellar: :any_skip_relocation, monterey:       "39d437203c8ba21dfcdc447f07003583db820fe8bd7b9042de28d38f9ab78a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4117af106b015c769682728fdb572170d2a78040adb6a7e53bd0f90f4f1611f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"mock-kubeconfig").write <<~EOS
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
    EOS
    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end
