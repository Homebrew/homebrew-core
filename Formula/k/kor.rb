class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "3bd1520cdfe4e67d58a78575a0ba6b242d40d293acad691274fd17a438d252df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "312cdcab19f219cfc11f133a785f9bcc1eba9fdb5735e95b8f47c048e06a1151"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3b4ab5766697d58fee881bf448bcb95c269144ad1789ac5d44ba068cf3a7063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37096624f3a7f28b029f349b1b18a5f38e4a2582d5345be7d972f7c02ee9f95a"
    sha256 cellar: :any_skip_relocation, sonoma:         "46438a7fb4124e8c0322a79c6a3dc13ad138c59171a7a168ca02512f1a9256b3"
    sha256 cellar: :any_skip_relocation, ventura:        "e1f4a1290cce31d2956ae2321a741e7e75ac4f11c33876a310917a2b1d8df605"
    sha256 cellar: :any_skip_relocation, monterey:       "538cb23892d6aeb85278c3dfae225daf6f961bd5840703c3e480428b5195a1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "602f4aa78cc8786f8f27e1f7d7e43d5774308df9f6ee32656e48b38c1f484e15"
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
