class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.3",
      revision: "5e3ab732df6aa32ac4b7cd3d560c5f66cc3e437a"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8269d58d0b11df8dc3c6f6f0e3cc6ca63e453ae7731384f4bfefe5d6af8d63a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8269d58d0b11df8dc3c6f6f0e3cc6ca63e453ae7731384f4bfefe5d6af8d63a"
    sha256 cellar: :any_skip_relocation, monterey:       "3b04a5efbce7da045ef03c1d19e5201b8024d93536dc1c24f310352a076d6abe"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b04a5efbce7da045ef03c1d19e5201b8024d93536dc1c24f310352a076d6abe"
    sha256 cellar: :any_skip_relocation, catalina:       "3b04a5efbce7da045ef03c1d19e5201b8024d93536dc1c24f310352a076d6abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2ede19bcf8e6ef2ea756f89887f3f63874f8bc8043488e78eb98c311440b6c4"
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
