class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.4",
      revision: "a8b652e59da9a3349ccb0e9d455c04c8d88e0868"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51b92385c38aab2948b04d8842fcf951cbb8a23e0103af735755ac3c98d1d14a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b92385c38aab2948b04d8842fcf951cbb8a23e0103af735755ac3c98d1d14a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b92385c38aab2948b04d8842fcf951cbb8a23e0103af735755ac3c98d1d14a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e15b38e209e4a0766b482d737b18ab9b92bbb71357e2aba0962f29b1d696f417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a135d6f2a584f6d7fad2595bb1f12e3a6f3e7bd7a773d54e511c7c19af2733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084a52402f48307cdf96dd08e3538d9a2cdc839e6f3c8ba67251d0d4c485ad72"
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
