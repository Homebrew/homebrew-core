class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.8.0",
      revision: "fcd721ffed6013777962befb68fff96424b67b06"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8b9c1cbe9250cce2ab24c377d483aa346d11ab12c234d1e179a710b0abaa65c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b9c1cbe9250cce2ab24c377d483aa346d11ab12c234d1e179a710b0abaa65c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8b9c1cbe9250cce2ab24c377d483aa346d11ab12c234d1e179a710b0abaa65c"
    sha256 cellar: :any_skip_relocation, ventura:        "578c0f080090c88f9a0b5673ca5c0d227de8a3ef7e65acd0a95bc211ffe5fd6a"
    sha256 cellar: :any_skip_relocation, monterey:       "578c0f080090c88f9a0b5673ca5c0d227de8a3ef7e65acd0a95bc211ffe5fd6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "578c0f080090c88f9a0b5673ca5c0d227de8a3ef7e65acd0a95bc211ffe5fd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ebd78a24764f2266e19e1344e061594e32160a24065bac38641c64c12c00737"
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
