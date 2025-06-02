class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.3",
      revision: "ef9b6f3cc10a4b6871b5698ca41fea3f6b3bcaec"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cabadfd79656b59d2eb525d54b4653664062a35f75b0cb4f862d2105d514b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cabadfd79656b59d2eb525d54b4653664062a35f75b0cb4f862d2105d514b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cabadfd79656b59d2eb525d54b4653664062a35f75b0cb4f862d2105d514b26"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a22ac50dbab34cb2083bf1e3bc0bc3162d21385eddc3abf9748d0c272ec4392"
    sha256 cellar: :any_skip_relocation, ventura:       "3a22ac50dbab34cb2083bf1e3bc0bc3162d21385eddc3abf9748d0c272ec4392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5bacd3f4cdb33aaac5b4bcd1e3478413406f2336a3375f60475dfcd4f848f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2251670c7e47e8fd9c02a25295e7e03c16aa269a151f5f3321e8b16662c3e539"
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
