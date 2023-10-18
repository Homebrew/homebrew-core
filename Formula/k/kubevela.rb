class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.6",
      revision: "9c57c098783fabeb76428cf88720a5a02ca641ee"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2417f53176d3513922a253c8fe3385f9c115d3817bbfe204fd8536008686670"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7adcbae6b18d0dcb9abce91a57a10d33be955b4919e196277a0bc3dab8773b84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7adcbae6b18d0dcb9abce91a57a10d33be955b4919e196277a0bc3dab8773b84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7adcbae6b18d0dcb9abce91a57a10d33be955b4919e196277a0bc3dab8773b84"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7fe42c270d25d7b399e6515b0dd43c60432490543680d8df24149b1cb9ef759"
    sha256 cellar: :any_skip_relocation, ventura:        "0834d5ab79bb68aca261203bf540b45a48f6fc0b1a067aa8b1853b69967aba6b"
    sha256 cellar: :any_skip_relocation, monterey:       "0834d5ab79bb68aca261203bf540b45a48f6fc0b1a067aa8b1853b69967aba6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0834d5ab79bb68aca261203bf540b45a48f6fc0b1a067aa8b1853b69967aba6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7917062765f69288cc00959046b8eccc208f7bc37a8bf797d9bb31d8fc5140e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags: ldflags), "./references/cmd/cli"

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
