class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "3f8b0577d47f3f7166b02d3839413592c0ab2fb2109c11cf69368e0ba93bf7e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4f20eee3cb1618fc301605c1291727669e91d632ae61bacca9c827367f0eada"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "205bad7bb51b580daeba950731951cae69a363d221d887eb422471d48fac2aed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae92eeca871e60ee673b666e7c969fc6de11934670277fbca5d2e897286ec1a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "849389b5d5ffa0ee1a297120b8a52776f3ed88c13d2d6a0203bbcb5ae96079c0"
    sha256 cellar: :any_skip_relocation, ventura:        "ce7ecaa4a07d2917066ec0e325c667d6a22ddafbe2bba469b391e6389d8e6473"
    sha256 cellar: :any_skip_relocation, monterey:       "6a6e88ba05295af1e2b4df2c92a0c19173e16e62885f7f889f6ba26fbe5f229b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fbd3dd0df733b3ebd6a8920410c59ec9597b96646ede7c9c0c3f309c647f9a5"
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
