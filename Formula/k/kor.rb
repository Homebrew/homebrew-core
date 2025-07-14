class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "949b5857f126b4a237daae3670b115b6671fb8c233fd5569d2897635f867c2cd"
  license "MIT"
  head "https://github.com/yonahd/kor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31275612e3e476d5047283d9ca94ed3e6ef837b2e5f8b0ab8b495d9789eae542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6d3c5ebb828e74eb0654983c9725b700e523a9ad65683d8008db9619618113"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8370d440712f082fe7e6a68e9d4e794f85c04213ee379ada103bffbad32bc513"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4732b6723d5dc195bb5258085e4e5d5a3dee97429f76e41698ec9416f5ec672"
    sha256 cellar: :any_skip_relocation, ventura:       "91affdfcff34d36ad82f851b7b7ab90193464c5410b797dacd1174e9e88d54d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4659212b65a1845b56de8f3688617729e3f443122510e192cbf2ee263dbcf652"
  end

  depends_on "go" => :build

  # skip kubeconfig for utility commands, upstream pr ref, https://github.com/yonahd/kor/pull/457
  patch do
    url "https://github.com/yonahd/kor/commit/6c02951894e587c023e57a7ab2654136024bff70.patch?full_index=1"
    sha256 "98b3dac34c1164831a25502f8c2723d227cdac8ade8e4f68b17b00057e149be4"
  end

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
