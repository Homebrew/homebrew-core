class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.1",
      revision: "6e9063d40c4c2ba79fbb6a0bfeb7c238ee68a748"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cd8195744c3dbca70915966fd5587077c6baa6b7c9cc231d062875903d604e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cd8195744c3dbca70915966fd5587077c6baa6b7c9cc231d062875903d604e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cd8195744c3dbca70915966fd5587077c6baa6b7c9cc231d062875903d604e5"
    sha256 cellar: :any_skip_relocation, ventura:        "336173a2daf01784582e70ebb64b061ab752236a7c35e24fb5fe3424a17594d3"
    sha256 cellar: :any_skip_relocation, monterey:       "336173a2daf01784582e70ebb64b061ab752236a7c35e24fb5fe3424a17594d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "336173a2daf01784582e70ebb64b061ab752236a7c35e24fb5fe3424a17594d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206a8af6905f683683dcfb68b7b8a224a13a4f8fb6ca2a7bf7f2267b3f009b1d"
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
