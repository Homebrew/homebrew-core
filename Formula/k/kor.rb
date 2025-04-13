class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d6c123fbaa0f1ad32e75cb0f33b493672845a4373b3fd116c369a9bcdcdf5940"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9059c95c7a0fe71096bcd717a097be83d2cef975bf57c2fcd3d66fdfdebf7d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356db7a3454ae138d2055130f995eb4518716c8419e79aa0676d49f0ce4b1beb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90b853401b7021051d2c9ea707a02bc5bd2954236b5168e62027464dfb93b171"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c115047ad5faed758af251530e8686ff325ea28fae879dab427497489e0c452"
    sha256 cellar: :any_skip_relocation, ventura:       "5bcb1866d0bc23e5db1c8173b1c55c0c66566dd72d1000378c4474f8696ac531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17832fb24098cd7448a0c72c2c7dce7dc17e20c5028a791cdbb9e3eee53bab5c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", "completion")
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
