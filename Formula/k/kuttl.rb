class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://kuttl.dev"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "9864535b0e4d90532772d617f010f80d07f82893098e1b6fb49ab19cb51e83b4"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918fa1e24cdd516f175d2a94942ea2e2668c68ae62fa92e6833789bd827cae3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918fa1e24cdd516f175d2a94942ea2e2668c68ae62fa92e6833789bd827cae3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "918fa1e24cdd516f175d2a94942ea2e2668c68ae62fa92e6833789bd827cae3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "15487e70e0068aaa8bd481d906d0e65c7679db4b16feb1411e2c5c3c2caed4ab"
    sha256 cellar: :any_skip_relocation, ventura:       "15487e70e0068aaa8bd481d906d0e65c7679db4b16feb1411e2c5c3c2caed4ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f95a24587b56221a5b7577326e98d3142497943442ad66a980bc4dadb28c65"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.gitVersion=v#{version}
      -X #{project}/pkg/version.gitCommit=#{tap.user}
      -X #{project}/pkg/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-kuttl", ldflags:), "./cmd/kubectl-kuttl"
    generate_completions_from_executable(bin/"kubectl-kuttl", "completion")
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
    assert_match "fatal error getting client: " \
                 "invalid configuration: " \
                 "no configuration has been provided, try setting KUBERNETES_MASTER environment variable", output
  end
end
