class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.4",
      revision: "17872f97050bb0d039b6f7f0f7245fe7f714fe9f"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e7210ea14bc159bf21a5e154f6cb7489a94fc70cfe4b79e543d113cd7fdc98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e7210ea14bc159bf21a5e154f6cb7489a94fc70cfe4b79e543d113cd7fdc98"
    sha256 cellar: :any_skip_relocation, monterey:       "233b0d89e3508b8e35087fab11f0e825f7b0e29eb0b5b6965acf3ad0bf2fc084"
    sha256 cellar: :any_skip_relocation, big_sur:        "233b0d89e3508b8e35087fab11f0e825f7b0e29eb0b5b6965acf3ad0bf2fc084"
    sha256 cellar: :any_skip_relocation, catalina:       "233b0d89e3508b8e35087fab11f0e825f7b0e29eb0b5b6965acf3ad0bf2fc084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e79e8d39e0bf6f068cebae26eebab2e48359ac8d8c88e27a04edd617fef20e9"
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
    assert_match "error: no configuration has been provided", status_output

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
