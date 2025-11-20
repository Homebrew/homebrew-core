class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.5",
      revision: "f89622eec7907e55af3067f0691ca0c0f38ef8e2"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "292feba37e326f494e9a482fe4bccfa6015b36bb7397c99609c2022d8f8627dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "292feba37e326f494e9a482fe4bccfa6015b36bb7397c99609c2022d8f8627dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "292feba37e326f494e9a482fe4bccfa6015b36bb7397c99609c2022d8f8627dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b36ed7529d87322a070d6baee8d2ad0c7c214b4c947faa5c55c354865d76b673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa8d384d9e96d9e49c2252d3087029319f3e9c257ec552efafcb6ea33aaf0635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "916b274166391db43b24c9d8fccf189b55095d39d7d6e23b3bef50d4cff0e6b6"
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
