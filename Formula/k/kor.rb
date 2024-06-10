class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "8af2b90c0fbca62ece06cda93a5ca82a054a4edd48eea936cc03120bb241c866"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94e0687b2870dde7611e63c8761144baddf15d82c3422cb6f5290a0c59fc9969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b15e447d8160cc4c505cd801b94d8cd3a5d65481463cb18d5716cd4dd888b711"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38cffbb4bcd990f64a9f5f651e09014551d90ee3546cfb305cf249c6121bf2a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0034256adfc932d44b6051e0b51456c7af2ee7667026c9a3f50decfd6e95080c"
    sha256 cellar: :any_skip_relocation, ventura:        "ed90e8780fa19d16fd7fd711d864b555ea8b56540c4dbf0ae9fdd18831c26d08"
    sha256 cellar: :any_skip_relocation, monterey:       "37f7b4e5a3527d19addb86961897c55f2a92fb8d7078b566f07ecdce0b3310d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dddda08d334721ab72accd72bcb5d93bf84d08e5582d9c04eb25ee1ce31104b7"
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
