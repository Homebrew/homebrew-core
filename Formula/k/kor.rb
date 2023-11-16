class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "078403454fe397f3ab894e2f226537c56b9ddc2db3c29ebb24ee90d511738735"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff1402ac31210693e441b7a7a15598ef797cd9442aef295fd4b7ccaa3c31a192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d186da2d0cafab366f591c967beb2eaac61464239b11d5af9f5f5538ef344513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d4e001b5a206f2f035ccc2d5f8b8f3c94e47169d1eb82121d823bcb9ec658a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "59743bd2e86cecce2f2e95985d0a161ff315ef96b37411b9e6d62c0e15c387c1"
    sha256 cellar: :any_skip_relocation, ventura:        "fc48c8c2754748230beb6b2b79f0dfe2e0617d7ce1f11412a827c928c6afd87e"
    sha256 cellar: :any_skip_relocation, monterey:       "5d00409cbb687507ea9c1570ae4cd5f3323797db26095025f1e25651c98688cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a617ae7366f312a26f5b1219a7ec1bfd66d2ac91a5bab9c685865a4e24016d57"
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
