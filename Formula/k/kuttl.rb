class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e2d78bd4896e7a5484da4e2d00fc4756c258ec4e8512b8264bcf6b5354b6f056"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    manifest_sha256 "67943d8ae123d3ff03b4db30824f7da2fe978a3eb502d3767ebd0b6a8c959851"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c373d20a2189c796e01a0ea310c626143554cfd997c82671420faa6462a3ea34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c533509932a27a31392e9d63ff6a48a8bef2858ebdb3d57d850f2aeab61879f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2df9160156e122da8b6fcf4bb0ed5fcccaf09131d96598ee6c0fbb3e9c0c99bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e7dbfe8ae20e7fec0bce162ac1602b159698ac75e9faa912b3e52e88430a68f"
    sha256 cellar: :any,                 x86_64_linux:      "91717de9881927c38290bdcacd949d996bf151557866f83661a52ef37d496870"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -X #{project}/internal/version.gitVersion=v#{version}
      -X #{project}/internal/version.gitCommit=#{tap.user}
      -X #{project}/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-kuttl", ldflags:), "./cmd/kubectl-kuttl"
    generate_completions_from_executable(bin/"kubectl-kuttl", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubectl-kuttl version")
    assert_match version.to_s, version_output
    assert_match stable.specs[:revision].to_s, version_output

    kubectl = formula_opt_bin("kubernetes-cli") / "kubectl"
    assert_equal version_output, shell_output("#{kubectl} kuttl version")

    (testpath / "kuttl-test.yaml").write <<~YAML
      apiVersion: kuttl.dev/v1beta1
      kind: TestSuite
      testDirs:
      - #{testpath}
      parallel: 1
    YAML

    output = shell_output("#{kubectl} kuttl test --config #{testpath}/kuttl-test.yaml", 1)
    assert_match "running tests using configured kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
