class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.9",
      revision: "65dedda40a69cc1eccf4072a4c835e5b9f13334e"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "916426e33667b95ce86004ed3be5416a7d77097e50aedc65c48e4c30427b755b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916426e33667b95ce86004ed3be5416a7d77097e50aedc65c48e4c30427b755b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916426e33667b95ce86004ed3be5416a7d77097e50aedc65c48e4c30427b755b"
    sha256 cellar: :any_skip_relocation, sonoma:        "57b15ccb79aa2eb3481006e66657f6c423cc7bb23f991ae1de50d1b324b5af2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08d6f826b724431d2bc71e7420a66a1db1efe407ad5a9f0fda6e3f6639ce8b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d56e77fd3905c180ad56e6a40fec23850327a2e48851a821859f2503eb233d0"
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
