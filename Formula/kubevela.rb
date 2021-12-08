class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.1.13",
      revision: "8de36ff2950b3c757f912e81d2fc4be3ea4b60af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2710a4a7230abf62aa7072899e597728f95668996e52aa3a4d2142acba2278d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91beb748bb1baea49a200b9e934fd30e554f3f8e99127383932963f1aadb47ba"
    sha256 cellar: :any_skip_relocation, monterey:       "effc058de8ae8c6fca9e9d1f22e9881e1eafe8c01ca42e66e04b887248939746"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb0db86500b6c4937815d8f4bb81911dc56c29e0389a8493b7544c282de8fcfc"
    sha256 cellar: :any_skip_relocation, catalina:       "7ad7c94a35abe1e6bdf149fa1ae556afa3a231cfa700ea0dd771bd36bafd26b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6897864cf9d25f2d7335ea376c13cadc89623b41e972ac001e838c91a79df0f6"
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
    assert_match "get kubeConfig err invalid configuration: no configuration has been provided", status_output

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
