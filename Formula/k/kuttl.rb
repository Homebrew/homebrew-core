class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "99d701c0fd9966e4ab77138a69137ec1f4d860f4fb6f6a9a89ef9141cb26eb08"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fc83b23e0dcf3a43ccb3d9aa0defd614acef5c50c526c41cf08d51fce38aa29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae013c44eb16040c6f70a80d53ab0182f54ccd988d063c619dad7bd8dd862c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90198c1580096be4519f8f66dafdb9b852c1f9e7eb2dcf28ee7a616eaa4af73"
    sha256 cellar: :any_skip_relocation, sonoma:        "60243331a7317009607264bb242a181c5507ebd8b8f76e262f9e58a755f75df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0af7eba6777470a949af6c589f1319f2f2bca1bae21c2a2067b9be81fec721a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944893f74680dbf82a27b6ca83d06825631cf5f573bece00a5336f782f74b43f"
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
