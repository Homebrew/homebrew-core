class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "c635a981f05ba3f1c21395348e858f6e4354455ae019b023e84fe408a29c2294"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36fa1bc7b373051fcf0b45601ce5ca8f05d3851bf37b977f2c935c863601c2e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af23bf965170c800f41a54113de23bbb4103a3862e2b998e614dbe30f3548f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ea9df23a16f3ad23dc4c7f2f9c5c7b8734e3f64a3966922ed25b808c86935c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2916efa9776111e48ca0b17e907474dc7eaa6134647910252d8368598802a045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ff651494040f6ff0d8d9e36f6fa17b29c63eda0271087d2c64a122aec45b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ffc1b4d3457f14e6ef1ad02ad3c91211651f40ac865534f44cdf3c4e6c40bd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
