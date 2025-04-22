class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.2",
      revision: "424e433963551eac070b4369829c4c674fce7ff1"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b3b88d32afaeeaebca3c03a5ebc49da7b04a0259a5375b343ec0ad73e5ca01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b3b88d32afaeeaebca3c03a5ebc49da7b04a0259a5375b343ec0ad73e5ca01f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b3b88d32afaeeaebca3c03a5ebc49da7b04a0259a5375b343ec0ad73e5ca01f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8d8717a7e204aa7358556879b976bdbad0027927628abca31ebcf1a968351a9"
    sha256 cellar: :any_skip_relocation, ventura:       "d8d8717a7e204aa7358556879b976bdbad0027927628abca31ebcf1a968351a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c79ef4542618373b30761469bd35789357339db001bb7a7afe5270e1b44e612d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480a53c891c435324c6ea1ed103091f4c012653d5171833fd1f26f0c7fb6c4d4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags:), "./references/cmd/cli"

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh])
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath/"kube-config").write <<~YAML
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
    YAML

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
