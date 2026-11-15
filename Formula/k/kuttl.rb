class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "265b82ec8e630a062f39b2b6dec63f547f8f2adeda19b62ac0c1b4e211a75a14"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3f1e6f88bc9d4cfe87a2893b900b087415e0627bf0f9b23397f331c75ace9e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e33304adb6afaf25055247eeeafb9fe514e4e2d19baff47faad16364384ce15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f267a97e70e2b60afe1b619db8df819ef893d635edb71fff2a3af750f990ef64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4cd272565ba2fc569de98eb6c838efde093bff7cb36b0ac42060226463094812"
    sha256 cellar: :any,                 x86_64_linux:      "a80b2a5ccc9950a9bfff30fe824b05cd5898f64b756e2cf6a8d1b8a028ec58cf"
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
