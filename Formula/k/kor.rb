class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "f94eb2df3e3edc3d8c4b73d193507375bf9145ef08086e60a9e5cd8f0a864726"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b5358d4d835e927be4b46ee89295b772aac6484df308547f4704e95b957e3f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c07af5e5bc9fba7716aa8eb0eb97c04b683388ab1a3bf480d972b2ae69b4fcce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebea71ba90bc80f5567429116d9e9cf15a4a6c0a73f30dfd3f76aba8b926d94"
    sha256 cellar: :any_skip_relocation, sonoma:        "9963bf6dcfe15a3e7a7d877f09778b4ea3a4346702dd377db1192532120fcb44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5183e05da2a8d36bad41181cbb6c968ce5be9a140292cedaa5654eb821430e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6235a0a600627de94c6b6a8ff9061472fa56d85de6f81b2566e6cbe4eceb2b9a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
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
