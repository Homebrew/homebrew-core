class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://kuttl.dev"
  url "https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "40ae409cbe7a8e742b703458800c921ccbcfbc1edbf30bf782169cd28d229f89"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81161bdf18633daf38a4e313d67f9b1a4abb328bf077a20d43d619cf99cbcfab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81161bdf18633daf38a4e313d67f9b1a4abb328bf077a20d43d619cf99cbcfab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81161bdf18633daf38a4e313d67f9b1a4abb328bf077a20d43d619cf99cbcfab"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaccad9db0a63f7b328e34fc22f2b33d191beeb2eb6072887edf90a2e251ae3c"
    sha256 cellar: :any_skip_relocation, ventura:       "eaccad9db0a63f7b328e34fc22f2b33d191beeb2eb6072887edf90a2e251ae3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf6a525560c04cc0501944f4da0075c1610f92da6d61888061a7ef9cf0f846b"
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
