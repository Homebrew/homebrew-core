class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.2.2",
      revision: "29ecc5c0df261369a504401fa5bbff1979667f36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee88445451669c33b281309db63998682770846d61e062dfdf2976a98c8f63a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee88445451669c33b281309db63998682770846d61e062dfdf2976a98c8f63a7"
    sha256 cellar: :any_skip_relocation, monterey:       "edf225f7366d4af977c3276a3296307d8f3a6a6f086acfaa9b4626cd9da5c173"
    sha256 cellar: :any_skip_relocation, big_sur:        "edf225f7366d4af977c3276a3296307d8f3a6a6f086acfaa9b4626cd9da5c173"
    sha256 cellar: :any_skip_relocation, catalina:       "edf225f7366d4af977c3276a3296307d8f3a6a6f086acfaa9b4626cd9da5c173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da38b9d71111bc8b6af0e8dc01b75758aeb05f7c4ba59b176b61588813603f76"
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
    assert_match "Error: invalid configuration: no configuration", status_output

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
