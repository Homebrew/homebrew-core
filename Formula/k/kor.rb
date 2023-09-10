class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "d2ba5816b770a24faade9a2cd8b22022b12ccc8c71744b927cdc5f1095f834f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a423f11a785712a52f2d38b05d84af8ab9d575770adcd9ae8239be1c4763856d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8555f8b59e50b2a5ce6c8c97db0a9270c85a004ec22f32a15f9b0b468da06624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "351ecd2787dbcb7211cc26aec66155c89b97b93ab1a8ede11b6ddffd31cb5a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "458afc20ed20d63675d66ffb4e5b1fa9fc59bab7af728a3f714689bc4081cc99"
    sha256 cellar: :any_skip_relocation, monterey:       "a3f94fa76325e156c5a6f4e9ed5ad4799e9d0369ecf5189dca63150d036d0c25"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8f4734b27e285a2f896c31a01aca5aaed170bd4ade912448dc938af61b1d7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f842470377f215d85ab63592d08328347882c62ccbd64c3c515af8647e8bbbe7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
