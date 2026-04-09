class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "3b92a5acb24f3db613974f51d5667724ad70c590c7b0ff9c697e2aa10a829b27"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6303812f327a32e3b73b920b4add24d5b26d78012131b59575b841082e32dcb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ea5271ddadf9f36f478f2ee3965d6599d08c244cfc1c799a59a100dd9f8f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a996d0e7916dddc9bf6494083647a8778cccd1ffec34fea3242289e70dca12a"
    sha256 cellar: :any_skip_relocation, sonoma:        "334dccceec0d32d9a8b6b140d6248692b21394d405cc1cb6d6a023417e6d5e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5c411baf3ea4b3f5fff733aff8b2a051b65332800c848e380cdede38e10f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6482d2e12015c7ec9429c12cd3c2db83d8d4fb617aad1142ef327d3f8c161553"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -s -w
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

    kubectl = Formula["kubernetes-cli"].opt_bin / "kubectl"
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
