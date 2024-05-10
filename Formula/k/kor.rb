class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "fc3928fb8ce43ea4b65d874508b424f027eb784d8276e28242062747c953f47d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b19c800586501e0920261e252f9e1a602e9d99cb70440ca2eec99bf2f7b7ea67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "334c722002af8d57f2d5a1fc55374a7505642ca89c1f22ba5a2bf2217a6b196f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d565acc199296d66d528396d327a8a3d4e258ebe9f8e46a67a268ec5974016b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac067e5ce783beef4693be423f28dc3ed2d379de3b1625b4c1b76d0241b43a8f"
    sha256 cellar: :any_skip_relocation, ventura:        "590bfd5bef02326b65fa7be2ef3f8f1e5cef0574e966211d3cb84b569623d059"
    sha256 cellar: :any_skip_relocation, monterey:       "06e2dc4f791a3e703855a47e1c6e7ae115c5f2d197adc49c0ec6faf3b0144e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "275c84c6f68055400b4ccf4eeb7a7050bc84077e1ef95e2475cccad674a65648"
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
