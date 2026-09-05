class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "2b354562dd032a629dec136bb38c288886f5d362dabbd2597bf9bde8628b59e1"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dac701ca478b47ae91e0001f3fbdf7c03d6ddf924819f74c38e5c2276d12cc10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "722638c29705dd0f21a39d0b7e933b56b35b7bf8187b70d06774fc1b76d62d08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85716b98a25d177c1a1714be3b14d4551e0230efa841a82d9fe8d384d52fc8b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49ec91bfea64cfc3dff65409d393d90caff7ec59f76879cb43cd023990ec6e6b"
    sha256 cellar: :any,                 x86_64_linux:  "ca4949616867ffc9b820f736f6db8b79ee50bc6f5fa1128d68226d48d1ed100f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kor version")

    (testpath/"mock-kubeconfig").write <<~YAML
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
    YAML

    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end
