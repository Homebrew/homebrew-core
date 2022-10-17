class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.7",
      revision: "18d755ed726ad98bc018569dd0348142050ea386"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b970bacc9cd48070eae58a42eee07b2ddddac0fed70145a56997d41fec4ff7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b970bacc9cd48070eae58a42eee07b2ddddac0fed70145a56997d41fec4ff7e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0dcb8d2ebdd55c3879abf7b81099409b07d00557ac6da239e2e8a626d42baa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0dcb8d2ebdd55c3879abf7b81099409b07d00557ac6da239e2e8a626d42baa7"
    sha256 cellar: :any_skip_relocation, catalina:       "c0dcb8d2ebdd55c3879abf7b81099409b07d00557ac6da239e2e8a626d42baa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "614ac89fb69fcd611f47915304ef29491a3fc6c9fa736dc671229033b2f3d760"
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
