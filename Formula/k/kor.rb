class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "b5067bed6bf719b00b7d6c0489e8b8590956e88f62e8fe2d7f1fd466f3c3e951"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "265784b07691075065f11d13df5c86ee4f3376e97798a7d4322b2dc8849c3fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1aaaec24c74aa30adc3c0b7b41d7e84963a088e1e0972763145fb83b930e9f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5551b8f9d9d43ad2143b46d3833b45a59abd13dd0cf195a7f79fdeda96aaffe"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cb31605d1492ffac8febb753ddfddd61a681bbedef29030dd38072e88445656"
    sha256 cellar: :any_skip_relocation, ventura:        "ff55deda2dfd2f0b713d7be471de8582710bab661ee70369866a1af2cd240186"
    sha256 cellar: :any_skip_relocation, monterey:       "9e6fb54dfd30dcc932703542240682bbc0be0c0dcfe72be2b55f2091e5fe5407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b96ed4b3c06a1253e7f83d91d785cc90699b9e56a32a12b1bb54e1c34c6651f4"
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
