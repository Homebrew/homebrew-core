class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e04156323083ad8d59d2e46a36544e1ce175965ad62fde5bac313364d2e4f26f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b90ca1894137b5d63abd0e37cb4db95d0bc1153e82d4577feb770ac81b8fc72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34803c867c5ae0e34b923093929c45313a9809c4c4eb6748d7af7d17a0c03bba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6d7cef3eff3f81b06c0fcff16053ac6eb550ac6c82e836f4fce7117854418e7"
    sha256 cellar: :any_skip_relocation, ventura:        "0d90e6a98e03f14a0dc9cbf6256c606bacccfb0020fe1cdc605894da75e6f710"
    sha256 cellar: :any_skip_relocation, monterey:       "4965d23e3084e5517273b15a56293e035dc9f4f81bd29fbbb4aa3962b7e1d920"
    sha256 cellar: :any_skip_relocation, big_sur:        "676f3d7549abdaea7e94c8d9918c5c4ce4e0f832735722455dd6930009d84de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4032a3389ceaec792ea15659631df198607f9c9f38876a980096397c7bf7f85e"
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
