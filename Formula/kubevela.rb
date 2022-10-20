class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.7",
      revision: "18d755ed726ad98bc018569dd0348142050ea386"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf32d104d70c57ddd17b97afd79b0c219ff9dfa316e1872cf336d03222f3b3d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf32d104d70c57ddd17b97afd79b0c219ff9dfa316e1872cf336d03222f3b3d1"
    sha256 cellar: :any_skip_relocation, monterey:       "e619011ca4cbebfab284a92e5e2942e9c68cb4fb7acf21ce9136ade85f53d422"
    sha256 cellar: :any_skip_relocation, big_sur:        "e619011ca4cbebfab284a92e5e2942e9c68cb4fb7acf21ce9136ade85f53d422"
    sha256 cellar: :any_skip_relocation, catalina:       "e619011ca4cbebfab284a92e5e2942e9c68cb4fb7acf21ce9136ade85f53d422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b473714b57243144b893c787ca6acedf979c4f3e2badda221f0954fa6ef085"
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
