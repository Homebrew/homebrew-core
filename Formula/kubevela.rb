class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.7.4",
      revision: "f3cdbcf203ba68bbbfec491e1e692ce808ba873f"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94a42c64d957b73f442f1f33871b268aafd8b0c513d360eb1059dd0822adb7eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59f8e27a624d9deca31d4f99668876a9926c6840973106a082e1fb2d2703f7bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b776338931a4a46054284b26cde16f8263e6538a33c1d8fd1bd4b5bcec649a2"
    sha256 cellar: :any_skip_relocation, ventura:        "ff6e434fb82d252b9babfca6ca7239a80bc95691eb35efad44f04f1989ee9805"
    sha256 cellar: :any_skip_relocation, monterey:       "ecdaa83ddc64c93756b27bfb8da4bb41295c13067b8879b03a8e24a9eff77b2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "86d583d75bf8eb21e3f166668b22d56af500ca23b6c5191da60fd0f8a538c9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6965ef1947b243687b571573b876814da476115e7c8a9b7471f01b7d80cf214d"
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
