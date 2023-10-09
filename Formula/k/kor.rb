class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "a685e2e8807f2357fc6b73b9bf69cab679830ed57ace5854791539cfbd02b52f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8bb323b5525773451663c280d6d3c790275331b097dd6defbe2328d311bd0c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "520442b3209e8fd54f54d8c243380f60c93e8251331dee16ca01f53e1c1783dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "992d62fbae82237d025d5e2860514a53a5142f132c9cda26f888672a1b1442e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e8ddd1e448d72c9236917cf1553e87fa6a805107283a09bf144af2c52c6a838"
    sha256 cellar: :any_skip_relocation, ventura:        "67a646142bdcc5d2ff4bb83331af6c80662622eaf7ec0c0d1c59383b9f4b316a"
    sha256 cellar: :any_skip_relocation, monterey:       "3871f9b476c03a5fbc168045cd3475816b147e151e43809a2bdc3b0320ad3d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2575ed868b33ca8df66c89eaacb79526f134af2f33683ca4030ed9e11ede51b"
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
