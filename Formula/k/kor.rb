class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "3b3dbe74e2cb1a5b059ea087996b66f1fae3b8082734deffb0debee0b6c61be7"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81c8fbb216b7967e97619fe1fd48d06b064fa559f2ec5f87963365128c8cb204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714d50541ed5ca508388e94854f33eb3b7a54f61c3ae07632c60c75031e065df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9289c107712df9795247f49b4a08436f014885b8c5765526e9510c514feb4c49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71172adb348b393c81847f370a7bc4264d7ffd45152e410af4b4926ca87030b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ba6e593f502112ecb199b22fda4f3212f39f1dd951e66887c470c1e6683896a"
    sha256 cellar: :any_skip_relocation, ventura:       "75ffcdce1455f0486de45104dd949d939d1e8940cd1d913d3dd48d718799578c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e135043f8070c37c0e3e258edb40770e4f31aae74b6582f3cef7b5052fa3ca"
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
