class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.7",
      revision: "b11eb845b28ee2176c9aaf32a6a4d8af2f62b06e"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95add397ef55193dbdf1ac8ae71fabf0df2cdffe012b3683a16ef3a637b4ce7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95add397ef55193dbdf1ac8ae71fabf0df2cdffe012b3683a16ef3a637b4ce7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95add397ef55193dbdf1ac8ae71fabf0df2cdffe012b3683a16ef3a637b4ce7d"
    sha256 cellar: :any_skip_relocation, ventura:        "1e3c1c8e1e8388bc328ebf70c3542b59f15b2da1e45e8ca1be46f8e4aaa2ce98"
    sha256 cellar: :any_skip_relocation, monterey:       "1e3c1c8e1e8388bc328ebf70c3542b59f15b2da1e45e8ca1be46f8e4aaa2ce98"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e3c1c8e1e8388bc328ebf70c3542b59f15b2da1e45e8ca1be46f8e4aaa2ce98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28a02e425da9372174d898bf45cf12a8dfafa057129bc99a7472e50a1dd58f9e"
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
