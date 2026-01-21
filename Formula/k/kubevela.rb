class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.6",
      revision: "bbbdd0d299d704b5a59bc09bf35858200ec06bd3"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f16be94fbd7d3935ee01b5373fab094b937643c2021a3c3887cca67b7f087c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3f16be94fbd7d3935ee01b5373fab094b937643c2021a3c3887cca67b7f087c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3f16be94fbd7d3935ee01b5373fab094b937643c2021a3c3887cca67b7f087c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a7c7430ca250db33ca84a7034ed4c500563cdc330c26c493d318b4cfc0d84f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "561d339001f7440d3abecdcc55ed946b4746f0b7cdc83d5a4047832ce6fd9461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfb3eb5f79a8539795987b3b755a405575365f77efebcad246fc0419ef2c4dad"
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
