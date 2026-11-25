class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "0e568ced8149faadc8bcec2d3d4af35f6a0153c98604395a42e2b1244fbf455c"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    manifest_sha256 "5d18ed31027e20f3c1a334c18462bb4680e2adadfc3df1c508d9132e441115e6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f13066f496019e978f5d5c3f7392d7acede3d824181056e49820e7b4add4cec9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5e1d4386c0e8375b5921f0270de4c6c55d4bf948e34abe4ecf5c78a019ccf0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19a4f015ad6defb32bc6cc26a561876dacf64a5f8146f0fd671dd53e133f1d13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ca5d436274157d75071d31168e940e8dd4b674e66a3e9f9fb47e22eb9e6c06b"
    sha256 cellar: :any,                 x86_64_linux:      "26b26cdb05c3d242acf36ae1a4c677cd2689c17f12706dd240624de413f1abad"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
