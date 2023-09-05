class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "f76180c4b323d9ed31ff399e2a97d67993bb17d8463f10e911dba3862017e043"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c33be9544c11d5247ff68d4df1184b16696f2c3051c6500f02266bef9e222d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4599ce1fba339936f6e81f493c81815a926adeef8f7bac96c9782d54ebff19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d15b19690ce430338ab80b651824228032a04add81c16631337b55d673d9c802"
    sha256 cellar: :any_skip_relocation, ventura:        "daba0ba77059b30962cabc3a41e22dbcf3347a417cd2932e5688d790bd3832a0"
    sha256 cellar: :any_skip_relocation, monterey:       "74e2c6c7eb5cbbc165e0a4d8b7d59bd21a0b42a6b4957bea4716c9ff9ff0657d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0556996b1f257bd929727cdf43e579fcad1295ee0a77fc74a268908587e1ab37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca7bf53c394c7cea0b3a0297f2ad9784555515cdab12ee768787cb4f5c9f36a"
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
