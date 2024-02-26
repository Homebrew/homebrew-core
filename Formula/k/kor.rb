class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "ad5e8d007c52c8f59ff1866368cef836f6aae1bc452260c1e63076bfb66a031f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d298f9d1a70a27154d2be1003ea8f35b8d73e77f19caf5565ea13e30a30eccd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0f9c4287e0f52bb6643ef8c18a66f97450c0e1683227ce70f5d6a384f87880c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ba8dcc056dcebd900f805b5c27aecb6033c7a1da006c8baf376005cf0579a49"
    sha256 cellar: :any_skip_relocation, sonoma:         "842fe9cba19a5128f5685d293fdb8747a4e370605f08ccd0a12fd44bab95363e"
    sha256 cellar: :any_skip_relocation, ventura:        "132e9a693ca69e0208293c4b3ce80c09def3e8bfffc430b5437c5c77f8fbfec0"
    sha256 cellar: :any_skip_relocation, monterey:       "d5305bd43990d7cd5e27e35ba651cb18802082f9da38dc111ffd98b7dbe349bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4891f3aed9475777c0ea9a401deb46d286a696f55b914bcc453ad726c73fd269"
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
