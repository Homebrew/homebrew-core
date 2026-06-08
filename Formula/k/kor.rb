class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "e651f3178e8c9cc1cd522661ac129b2518ed3fc981b0a9eebdf531e9c0b17b17"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19631214ca39488de9cb9652248366b3b22dcbedb62a60c8a75c9b6b968c4d7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708c4f566ca41e4136dd2c4088cdb942270f716403e73bed80d4b653b9fdfa4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6df9499ca85e87ff2b0ece0e30c7d2786df8f9bd684224025c9bb48436371126"
    sha256 cellar: :any_skip_relocation, sonoma:        "d288512ae7cd50e6b2fd9b488f73c03b7f09c0847e3f5aa349c62983b64ab8aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1079d82cccbba5fb6d7680ca682f6e97ff8d539363236dd764de2ae372ed2976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77de8e7bbe0abf0cf5f3c3f7d9e42192ac5dd0b75bcc828745aa2c9a4d4dff25"
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
