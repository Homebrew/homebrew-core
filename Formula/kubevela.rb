class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.7.5",
      revision: "1c2df10299dfa015f34011317fa2b4a109988407"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d85a5c77f2814c53d9d07f52840171e2f63d0ee667032886c50c87dc49ac303f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d85a5c77f2814c53d9d07f52840171e2f63d0ee667032886c50c87dc49ac303f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d85a5c77f2814c53d9d07f52840171e2f63d0ee667032886c50c87dc49ac303f"
    sha256 cellar: :any_skip_relocation, ventura:        "e1378bacc60d39f83f0ddc3b6e4a965d6aa652c83328e0b55be924ebbaf0edd5"
    sha256 cellar: :any_skip_relocation, monterey:       "e1378bacc60d39f83f0ddc3b6e4a965d6aa652c83328e0b55be924ebbaf0edd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1378bacc60d39f83f0ddc3b6e4a965d6aa652c83328e0b55be924ebbaf0edd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3354ccfa17ff9a7ced207b6b63c83086ffff6d7928e46026153afaa413efd431"
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
