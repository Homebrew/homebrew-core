class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.4",
      revision: "1a6b7244c87db4a499e291b7138c9f4ca1afc2ac"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7639385f95b8f8a6f899c023824ef75d4ca56eb07d36e281fcc45f89fa8395a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7639385f95b8f8a6f899c023824ef75d4ca56eb07d36e281fcc45f89fa8395a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7639385f95b8f8a6f899c023824ef75d4ca56eb07d36e281fcc45f89fa8395a"
    sha256 cellar: :any_skip_relocation, ventura:        "677486757d0bedfbd2c798894038599e28a3af902582da614da74e3e23d807a1"
    sha256 cellar: :any_skip_relocation, monterey:       "677486757d0bedfbd2c798894038599e28a3af902582da614da74e3e23d807a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "677486757d0bedfbd2c798894038599e28a3af902582da614da74e3e23d807a1"
    sha256 cellar: :any_skip_relocation, catalina:       "677486757d0bedfbd2c798894038599e28a3af902582da614da74e3e23d807a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc86fd56d857ff8c11057c25c75a17252a61f7fa0e7f777753583593f25d0db"
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
