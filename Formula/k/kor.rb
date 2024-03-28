class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "3f8b0577d47f3f7166b02d3839413592c0ab2fb2109c11cf69368e0ba93bf7e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62a1cb797f0c031136c14496d4954436f4d47ecbb078313ca3dff634d3cd3ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b56e00df7d7dad69c5b79bc748eeb5b36619cea7c78b9735d27a672f9c4d730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4977be22bde686b99863f6e28b7b7b5ed9db6cb5768a4fd39592c8d77bf23211"
    sha256 cellar: :any_skip_relocation, sonoma:         "782d8276baa807da6a50a7538d88f8526f112a7cd706d3791d597cafb809ad8b"
    sha256 cellar: :any_skip_relocation, ventura:        "a4893b3ec8138b008b2ff67b14f1cb844488f16fd8d114a0ee2998ca805fb81d"
    sha256 cellar: :any_skip_relocation, monterey:       "6942eb2ecc6e0c50934c9371e4b1b20075614cd6c258b6d3c48fcdfb79b52768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0891941e2e29963f0b7a437af40ac76bece7d0e715df0c8d6b3a129d4f6833f"
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
