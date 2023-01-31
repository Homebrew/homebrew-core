class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.7.1",
      revision: "492e7d7f0d78888386260a22e27d0093d731d457"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd99db0e52ddd8872c091d37af8e0627e3004eb15bf796639191329964854b6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd99db0e52ddd8872c091d37af8e0627e3004eb15bf796639191329964854b6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd99db0e52ddd8872c091d37af8e0627e3004eb15bf796639191329964854b6e"
    sha256 cellar: :any_skip_relocation, ventura:        "792b8a80ce29ba50a53a2ec3625fdec2d38e2ca803387ebd7b6b1127c360be9c"
    sha256 cellar: :any_skip_relocation, monterey:       "792b8a80ce29ba50a53a2ec3625fdec2d38e2ca803387ebd7b6b1127c360be9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "792b8a80ce29ba50a53a2ec3625fdec2d38e2ca803387ebd7b6b1127c360be9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62515aca0c52e896e1b04cd8e5cfdb46842292066a443e8891fca0ee245143d0"
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
