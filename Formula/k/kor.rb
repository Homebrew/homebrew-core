class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1d6ea66ed25c17048edd6e12a99b57bc737f1424a5f2c9a2829d96814fa7842d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b73d7f332f2e4713fb224853bc6dc2593a3b47faeba274555a232ba833e7b392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55883761f9eb9181a2b5b3e5d990373e4082c9ec7a7f08b5e8f32f54c8522c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a51749c768f52f6e3e771c890c10eb7c9565345cc40a699326e0b467fb43176"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8a85ca9a7322b8a8acabb6614c11beb74674a99a087215cc8077ce78ab08d27"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3622dcbd9d3f74452198e8e3fab6eb6d87c3c12f783e018ea0b5e5b9003fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "d9db3d7fb17604559331c8c84ace68e7aff009be66189bf9e37b9981f82c71bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3824fd7de80e75115aee78510f6ed8b01c68617c72547133e08ae1a178c698b1"
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
